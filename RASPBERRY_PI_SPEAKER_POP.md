# Raspberry Pi MAX98357A Speaker Pop Investigation

## Purpose

This note records the Raspberry Pi Zero W and Zero 2 W speaker-pop investigation performed while developing mk-piclock. It explains the likely cause, the test methods that were tried, why they were not retained as the default, and why the tested Banana Pi M2 Zero build behaves better.

The conclusions below are based on the tested mk-piclock hardware and software combinations. They do not prove that every Raspberry Pi Zero will click or that every Banana Pi M2 Zero will be silent.

## Current Raspberry Pi release decision

The production Raspberry Pi wiring leaves the MAX98357A `SD`, `EN`, or `SD_MODE` pin disconnected and uses:

```ini
dtparam=audio=off
dtoverlay=max98357a,no-sdmode
```

This arrangement produced reliable audio on the tested Raspberry Pi clock. A small click at stream start or stop may remain. The application does not currently add a persistent silence stream, GPIO amplifier switching, or a software fade solely to suppress that click.

## What causes the click

The MAX98357A receives digital audio through three active I2S signals:

- BCLK, the bit clock
- LRCLK, the left/right frame clock
- DIN, the sample data

mk-piclock opens the ALSA playback device when a song, alarm, story, or chime begins. ALSA starts the Raspberry Pi I2S peripheral and its clocks. When playback ends, mk-piclock drains or stops the PCM device and closes it, allowing the I2S clocks to stop.

With `no-sdmode`, the amplifier is always enabled because Linux does not control its shutdown input. The amplifier therefore sees the transition from no clocks to active clocks at startup, and active clocks to no clocks at shutdown. A brief non-zero or unsettled state can appear at the differential speaker output during either transition. The speaker converts that abrupt step into a click or pop.

The important sequence is:

```text
Preferred startup:
SD_MODE low -> start BCLK and LRCLK -> wait for stable clocks -> enable amplifier

Preferred shutdown:
fade or write silence -> SD_MODE low -> stop BCLK and LRCLK
```

The Linux MAX98357A binding specifically supports `sdmode-delay` because the I2S clocks may need to become stable before the amplifier is unmuted. The documented observation is that 5 ms is normally sufficient. Analog Devices also warns that LRCLK should be present before the device is enabled, and that the device should enter shutdown before LRCLK is removed.

## Why SD_MODE control is more complicated than a normal enable pin

On the MAX98357A, `SD_MODE` is not only a digital shutdown input. Its operating voltage also participates in audio channel selection. Depending on the board's resistor network and the voltage presented to the pin, the amplifier can select the left channel, right channel, or a mono mix.

Many small MAX98357A breakout boards bias this pin through onboard resistors. Leaving the pin disconnected lets that resistor network choose the board's intended default mode. Driving the pin directly from a GPIO can override that bias and select a different channel mode.

This matters because uploaded mk-piclock music is stored as mono MP3. A mono PCM stream may not place useful data in both physical I2S slots in the same way on every controller and ALSA path. If SD_MODE selects the other slot, the result can be silence even though BCLK, LRCLK, and DIN are active.

## Raspberry Pi test history

### 1. Always-on amplifier using `no-sdmode`

Configuration:

```ini
dtoverlay=max98357a,no-sdmode
```

Wiring:

```text
MAX98357A SD_MODE -> disconnected
```

Result:

- Audio played reliably.
- The breakout's onboard SD_MODE bias remained in control.
- A start or stop click remained because the amplifier stayed enabled while I2S clocks started and stopped.

This became the production Raspberry Pi fallback because reliable audio was more important than an incomplete pop-suppression method.

### 2. Standard managed shutdown on GPIO4

Configuration tested:

```ini
dtoverlay=max98357a,sdmode-pin=4
```

Wiring:

```text
MAX98357A SD_MODE -> BCM GPIO4, physical pin 7
```

Intended operation:

- GPIO4 low while idle
- GPIO4 high during playback
- amplifier disabled again when the ALSA stream stops

The GPIO state was inspected with:

```bash
watch -n 0.2 pinctrl get 4
```

Observed states included:

```text
Playback: GPIO4 output high
Idle:     GPIO4 output low
```

The kernel was therefore changing the line. On the tested hardware, however, sound was absent with physical pin 7 connected. Disconnecting pin 7 restored sound. This strongly indicated that the problem was associated with how the tested breakout interpreted or was loaded by the managed SD_MODE signal, rather than with MP3 decoding or the speaker itself.

### 3. Open-drain SD_MODE experiment

Two open-drain test revisions were built. Their goal was to obtain both shutdown sequencing and the breakout's original channel-selection bias.

The custom overlay attempted this behavior:

```text
Idle:     GPIO4 actively pulls SD_MODE low
Playback: GPIO4 becomes high impedance
Pull:     Raspberry Pi internal pull disabled
Delay:    5 ms after I2S start before release
```

The idea was sound in principle:

- pulling low shuts the amplifier down
- releasing the line avoids forcing it to 3.3 V
- the breakout resistor network can then choose its normal mixed-channel mode
- the 5 ms delay allows BCLK and LRCLK to stabilize first

The experiment was withdrawn because it did not behave reliably enough on the tested Raspberry Pi kernel, GPIO, overlay, and amplifier combination. An emulated open-drain GPIO also makes state inspection less obvious because the expected playback state is an input or released line, not a normal output-high state.

### 4. Delayed direct-drive plus dual-mono test

The final Raspberry Pi audio test withdrew the open-drain overlay and used a simpler controlled-enable sequence:

```text
Idle:     GPIO4 low
Playback: start I2S, wait 5 ms, then GPIO4 high
Stop:     GPIO4 low as playback stops
```

The decoder was also changed to use `MPG123_FORCE_STEREO`. This duplicates every mono sample into both PCM channels so both I2S slots carry the same audio. The purpose was to make SD_MODE channel selection irrelevant.

This addressed two separate risks:

1. clocks becoming active after the amplifier was already enabled
2. the amplifier selecting an empty I2S slot

Although this was the most complete Raspberry Pi software test, it still did not produce a result considered reliable and click-free enough for production on the tested clock. The release was rolled back to the known working `no-sdmode` wiring.

## Why the tested Banana Pi does not have the same problem

The BPI M2 Zero release uses a board-specific Device Tree overlay rather than the Raspberry Pi stock overlay. Its audio path is intentionally defined as one system:

```text
I2S controller: Allwinner H2+/H3 I2S0
LRCLK:          PA18
BCLK:           PA19
DIN:            PA20
Amplifier SD:   PA1
Audio card:     simple-audio-card named MAX98357A
Clock ratio:    mclk-fs = 256
Enable delay:   sdmode-delay = 5 ms
Playback:       forced dual-mono stereo PCM
```

The BPI overlay keeps the amplifier disabled while idle. When playback begins, the MAX98357A codec driver waits until the I2S start trigger, delays 5 ms, then raises PA1. When playback stops, the driver lowers PA1 as part of the stream-stop path. The amplifier is therefore muted around the clock transitions that caused the Raspberry Pi click.

The BPI application also expands mono MP3 into dual-mono stereo PCM. Both I2S slots contain identical samples, so a left, right, or mixed channel choice remains audible. The BPI overlay also fixes the I2S clock ratio at 256, which corrected the earlier slow and low-pitched playback issue on the Allwinner controller.

The BPI result is better because all four pieces work together on the tested board:

1. a dedicated and verified SD_MODE GPIO
2. a codec driver-controlled 5 ms enable delay
3. shutdown before the I2S clocks disappear
4. identical audio in both I2S slots

The advantage is not that the MAX98357A is inherently different on BPI. The tested BPI Device Tree, I2S controller, GPIO behavior, and playback format form a compatible sequence. The tested Raspberry Pi path did not achieve the same reliable result with the available breakout and GPIO4 arrangement.

## Most promising future Raspberry Pi solution

A complete Raspberry Pi solution should treat startup and shutdown as one transaction instead of only toggling a GPIO.

Recommended design:

```text
Startup
1. Hold SD_MODE low.
2. Open and prepare ALSA.
3. Start BCLK and LRCLK with zero-valued PCM frames.
4. Wait at least 5 ms.
5. Release or raise SD_MODE using a circuit that preserves the intended channel mode.
6. Fade audio from silence to the requested volume.

Shutdown
1. Fade the final samples to zero.
2. Continue zero-valued PCM briefly.
3. Pull SD_MODE low.
4. Wait for amplifier shutdown.
5. Stop and close ALSA.
```

### Preferred hardware control

A dedicated transistor or open-drain buffer is more predictable than asking the Raspberry Pi pin to serve as both a digital enable and an analog channel-selection source. The buffer can pull SD_MODE low for shutdown while allowing the breakout's resistor network to set its enabled voltage.

A breakout with a separate true enable input is also preferable. It avoids sharing one pin between shutdown and channel selection.

### Preferred software control

The playback path should retain forced dual-mono stereo so both I2S slots always contain audio. A short fade and several milliseconds of zero PCM before shutdown can remove any remaining discontinuity.

Another possible method is to keep ALSA and the I2S clocks running continuously while sending zero PCM between sounds. This avoids clock startup and shutdown transitions, but it consumes more power, keeps more of the audio path active, and can increase idle hiss. It is less attractive for a bedside appliance unless measured results justify it.

## Safe rollback

To return a Raspberry Pi clock to the known working audio arrangement:

1. Power off the clock.
2. Disconnect MAX98357A SD_MODE from physical pin 7.
3. Set:

```ini
dtparam=audio=off
dtoverlay=max98357a,no-sdmode
```

4. Remove any custom MAX98357A test overlay from `config.txt`.
5. Reboot and test playback.

Never connect SD_MODE to GPIO4 and 3.3 V or 5 V at the same time.

## Diagnostic commands

Confirm the active overlay settings:

```bash
grep -nE 'audio|dtoverlay|max98357' /boot/firmware/config.txt
```

Confirm ALSA devices:

```bash
cat /proc/asound/cards
cat /proc/asound/pcm
```

Inspect GPIO4 during a managed-shutdown experiment:

```bash
watch -n 0.2 pinctrl get 4
```

Follow application audio logs:

```bash
sudo journalctl -f -u mk-piclock-core.service
```

## Technical references

- Analog Devices MAX98357A product and data sheet: <https://www.analog.com/en/products/max98357a.html>
- Linux MAX98357A Device Tree binding, including `sdmode-delay`: <https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next/+/refs/heads/akpm-base/Documentation/devicetree/bindings/sound/max98357a.txt>
- Linux MAX98357A codec driver: <https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux/+/fe5881ed7293813e492ad165292ae652b676ff6c/sound/soc/codecs/max98357a.c>
- Analog Devices note about disabling the amplifier before LRCLK is removed: <https://ez.analog.com/audio/w/documents/27472/dc-output-on-speaker-for-max98357>
- Raspberry Pi MAX98357A overlay parameters: <https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README>
