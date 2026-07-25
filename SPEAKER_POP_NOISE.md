# Raspberry Pi MAX98357A Speaker Pop and Click Notes

This note documents the start and stop pop heard during mk-piclock audio playback on the Raspberry Pi Zero build. It records the likely cause, the tests performed, the currently accepted wiring, a possible future solution, and why the Banana Pi M2 Zero build behaves differently.

## Scope

This applies to the Raspberry Pi build using:

- Raspberry Pi Zero W or Zero 2 W
- MAX98357A I2S Class D amplifier
- BCLK on BCM GPIO18, physical pin 12
- LRCLK on BCM GPIO19, physical pin 35
- DIN on BCM GPIO21, physical pin 40
- `dtoverlay=max98357a,no-sdmode`
- MAX98357A SD/EN left disconnected

The noise is normally a short click or pop when an audio stream starts or stops. Audio during playback remains clear.

## Why the noise occurs

The MAX98357A receives digital audio through three active signals:

1. BCLK supplies the audio bit clock.
2. LRCLK identifies the left and right audio slots.
3. DIN supplies the sample data.

The Raspberry Pi audio device does not continuously transmit these signals while mk-piclock is idle. ALSA opens the PCM device when a song, alarm, story, or chime starts. The Pi I2S peripheral begins generating BCLK and LRCLK, audio is written, and the peripheral is later stopped when the PCM device closes.

Those clock transitions are not always electrically silent to the amplifier. A brief malformed, incomplete, or changing clock state can be interpreted before valid PCM has fully stabilized. The MAX98357A output stage is already enabled in the current Raspberry Pi wiring, so the speaker can reproduce that transient as a click.

The MAX98357A has internal click-and-pop reduction, but it cannot fully suppress a transient presented while its digital interface is changing state. The Linux MAX98357A Device Tree binding specifically supports delaying SD_MODE enable until I2S clocks are ready because this ordering can avoid speaker pop.

## Why `no-sdmode` permits the click

The Raspberry Pi release currently uses:

```ini
dtoverlay=max98357a,no-sdmode
```

The Raspberry Pi overlay documentation defines `no-sdmode` as leaving the DAC SD_MODE state unmanaged. In practical terms, Linux does not mute or shut down the amplifier before starting or stopping the I2S clocks.

The tested amplifier module enables itself through its onboard SD/EN bias when the SD/EN pad is disconnected. This is reliable for producing sound and preserves the module's default mono mix, but it leaves the amplifier listening during I2S startup and shutdown.

The current sequence is effectively:

```text
Idle:       amplifier enabled, I2S clocks stopped
Start:      I2S clocks change, then valid PCM begins
Playback:   valid PCM is present
Stop:       PCM ends, then I2S clocks stop
Idle:       amplifier remains enabled
```

The click occurs during one of the two transition periods.

## Important SD_MODE detail

SD_MODE is not only a simple digital enable pin. It is an analog mode-selection input with four voltage regions:

| SD_MODE voltage | MAX98357A state |
|:--|:--|
| Below the B0 threshold | Shutdown |
| Between B0 and B1 | Left plus right mono mix |
| Between B1 and B2 | Right channel |
| Above B2 | Left channel |

Typical comparator points are approximately 0.16 V, 0.77 V, and 1.4 V. The exact limits vary. A direct 3.3 V GPIO high therefore selects the left channel. It does not reproduce the floating or resistor-biased mono-mix state used by many MAX98357A breakout boards.

This is why treating SD/EN as an ordinary push-pull mute line can create a second problem. The click may improve, but channel selection or audio output can change.

## Tests performed on the Raspberry Pi

### 1. Baseline with SD/EN disconnected

Configuration:

```ini
dtoverlay=max98357a,no-sdmode
```

Wiring:

```text
MAX98357A SD/EN -> not connected
```

Result:

- Audio played normally.
- The start or stop click remained.
- This confirmed that the I2S audio path, amplifier, and speaker were functional.

### 2. Driver-controlled SD/EN on GPIO4

The standard Raspberry Pi MAX98357A overlay uses BCM GPIO4 by default when SD_MODE management is enabled. BCM GPIO4 is physical pin 7.

The test connected:

```text
Raspberry Pi physical pin 7, BCM GPIO4 -> MAX98357A SD/EN
```

GPIO state was watched with:

```bash
watch -n 0.2 pinctrl get 4
```

Observed states included:

```text
4: op -- -- | hi
4: op -- -- | lo
```

When GPIO4 remained low, the amplifier was correctly held in shutdown, but no sound played. Disconnecting the physical pin 7 wire restored audio immediately. This isolated the no-audio condition to SD_MODE control rather than the PCM stream.

### 3. Direct push-pull and open-drain experiments

Test builds explored controlling GPIO4 around playback, including an open-drain-style approach intended to avoid forcing SD_MODE to 3.3 V.

The objectives were:

- hold SD_MODE low while idle
- start I2S clocks
- release or raise SD_MODE only after clocks were active
- mute again before stopping the clocks

The experiments did not produce a result suitable for the production Raspberry Pi release. Depending on the state and wiring, the amplifier could remain muted, select a different channel mode, or still fail to provide the clean and predictable behaviour obtained on the Banana Pi.

The production decision was therefore to remove the physical pin 7 connection and return to the known-working `no-sdmode` configuration. This restores reliable sound but accepts the possible click.

## Possible hardware solution for the Raspberry Pi

A proper solution must perform two jobs at once:

1. Pull SD_MODE below the B0 threshold while idle so the amplifier is shut down.
2. Place SD_MODE in the mono-mix voltage region while playing, after BCLK and LRCLK are stable.

The most defensible path is a custom Raspberry Pi overlay plus a resistor-controlled SD_MODE circuit.

### Proposed sequence

```text
Before playback:
    SD_MODE low
    amplifier shut down

PCM prepare:
    configure and start BCLK and LRCLK
    wait at least 5 ms

Playback:
    release SD_MODE into its mono-mix resistor bias
    write valid PCM

Stop:
    pull SD_MODE low
    wait briefly
    stop and close the PCM device
```

Linux already supports the important delay through:

```dts
sdmode-gpios = <...>;
sdmode-delay = <5>;
```

The Linux binding states that a 5 ms delay has been observed as sufficient to ensure that I2S clocks are ready before SD_MODE is unmuted.

### Resistor requirement

A direct GPIO high is not the preferred mono-mix control because 3.3 V selects the left channel. The MAX98357A data sheet gives a calculated pull-up value of approximately 634 kOhm for the mono-mix region with 3.3 V control logic.

A possible circuit is:

```text
3.3 V ---- approximately 634 kOhm ----+---- MAX98357A SD/EN
                                      |
                                 open-drain GPIO4
                                      |
                                     GND
```

Operation:

- GPIO4 asserted low places the amplifier in shutdown.
- GPIO4 released to high impedance allows the resistor and the MAX98357A internal 100 kOhm pulldown to establish the mono-mix voltage.

The exact circuit depends on the breakout board. Many boards include their own SD_MODE pull-up resistor. That onboard resistor changes the effective voltage and may need to be removed or included in the calculation. Do not blindly add another resistor without identifying the module's existing circuit.

This proposed modification has not been validated on the production mk-piclock Raspberry Pi hardware. It is documented as the most technically sound next test, not as a guaranteed repair.

## Possible software-only mitigation

A second approach is to keep the ALSA PCM device open and continuously write silence between sounds. This prevents the Raspberry Pi I2S peripheral from repeatedly stopping and restarting.

The sequence becomes:

```text
Service startup: open PCM and begin valid silent frames
Idle:            continue silent frames
Playback:        replace silence with audio
After playback:  return to silent frames without closing PCM
```

This can reduce between-track clicks because BCLK and LRCLK remain active. It does not necessarily eliminate the initial click at boot or the final click when the service exits. It also requires a larger audio architecture change because mk-piclock currently opens a PCM session for each playback request.

A separate background `aplay` process is not recommended. It can occupy the hardware device, conflict with mk-piclock, and does not guarantee that both processes use the same uninterrupted PCM stream. The persistent stream must be owned by the same audio engine that mixes silence and program audio.

## Why the Banana Pi release does not have the same affliction

The Banana Pi M2 Zero build uses the same MAX98357A amplifier, but it does not use the Raspberry Pi `no-sdmode` arrangement.

Its custom Device Tree overlay includes:

```dts
sdmode-gpios = <&pio 0 1 0>;
sdmode-delay = <5>;
simple-audio-card,mclk-fs = <256>;
```

The wiring connects:

```text
Banana Pi PA1, physical pin 11 -> MAX98357A SD/EN
```

This changes the lifecycle:

```text
Idle:       codec driver holds SD/EN low
Prepare:    H2+/H3 I2S clocks are configured and started
Delay:      driver waits 5 ms
Playback:   codec driver enables the amplifier
Stop:       codec driver disables the amplifier before clocks disappear
Idle:       amplifier remains shut down
```

The BPI build also forces two-channel PCM so the Allwinner H2+/H3 I2S controller always uses a standard two-slot frame, even when the source file is mono. Its overlay supplies the 256x clock relationship required by that audio path. These choices create a stable and predictable clock frame before the amplifier is enabled.

Therefore, the clean BPI result is not simply because the Banana Pi has better analog audio hardware. The BPI release has a custom, board-specific audio overlay that manages the MAX98357A shutdown pin and clock timing together. The Raspberry Pi release currently chooses maximum wiring reliability with SD/EN disconnected, at the cost of a possible transition click.

## Current production recommendation

For `v1.9.14-rpi-zero-r3`, keep the documented production wiring:

```text
MAX98357A SD/EN -> not connected
```

Keep:

```ini
dtoverlay=max98357a,no-sdmode
```

This configuration is known to play audio reliably. A small click at start or stop may occur.

Use the Banana Pi M2 Zero build when pop-free playback is a primary requirement. Its current Device Tree and SD/EN implementation produced the preferred clean audio during testing.

## Safety and wiring notes

- Power down before changing amplifier wiring.
- Do not connect either speaker terminal to ground. The MAX98357A output is differential.
- Do not connect SD/EN directly to 5 V.
- Do not assume every MAX98357A breakout uses the same onboard pull-up resistor.
- Confirm the SD_MODE voltage before connecting a speaker when testing a new resistor network.
- GPIO4 is BCM GPIO4, physical pin 7. These numbers are not interchangeable.

## References

- Analog Devices, `MAX98357A/MAX98357B: Tiny, Low-Cost, PCM Class D Amplifier with Class AB Performance`, Rev. 16. See `SD_MODE and Shutdown Operation`, `Startup`, and the SD_MODE resistor tables.
- Linux kernel MAX98357A Device Tree binding. See `sdmode-gpios` and `sdmode-delay`.
- Raspberry Pi firmware overlay documentation. See the `max98357a`, `no-sdmode`, and `sdmode-pin` parameters.
- The bundled Banana Pi overlay: `hardware/max98357a-bpi-m2-zero.dts` in the BPI release.
