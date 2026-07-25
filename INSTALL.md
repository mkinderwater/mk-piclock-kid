# mk-piclock v1.9.14-rpi-zero-r3: Build and Install

> Installation guide for mk-piclock Kids on Raspberry Pi Zero W and Zero 2 W.

| Product | HTTP API | Private IPC |
|:--|:--|:--|
| `1.9.14-rpi-zero-r3` | `1.26` | `16` |

mk-piclock uses two native C services:

- `mk-piclock-core` controls the OLED, touch sensor, RGB LED, alarms, messages, and audio.
- `mk-piclock-api` provides the browser interface, uploads, media processing, backups, and diagnostics.

Always install both services from the same release.

## Contents

- [Requirements](#requirements)
- [Prepare Raspberry Pi OS](#prepare-raspberry-pi-os)
- [Install dependencies](#install-dependencies)
- [Configure the hardware](#configure-the-hardware)
- [Verify the hardware](#verify-the-hardware)
- [Extract, build, and install](#extract-build-and-install)
- [Open and configure the clock](#open-and-configure-the-clock)
- [Upgrade an existing clock](#upgrade-an-existing-clock)
- [Reset a lost web password](#reset-a-lost-web-password)
- [Service control and logs](#service-control-and-logs)
- [Storage locations](#storage-locations)
- [Troubleshooting](#troubleshooting)
- [Related documentation](#related-documentation)

---

## Requirements

### Supported platform

- Raspberry Pi Zero W or Raspberry Pi Zero 2 W
- Raspberry Pi OS Lite based on Debian 13 Trixie
- libgpiod 2.x

The project targets the Pi Zero family. Pi 5 instructions are intentionally excluded.

Confirm the operating system and Pi model:

```bash
cat /etc/os-release
tr -d '\0' </proc/device-tree/model
printf '\n'
```

### Hardware

- SSD1322 256x64 OLED
- MAX98357A I2S amplifier
- 4-ohm, 3-watt speaker
- TTP223B touch sensor
- Common-cathode RGB LED with one resistor per colour channel
- MicroSD card
- Reliable 5 V power supply rated for at least 2 A

> [!IMPORTANT]
> Review `pinouts.md` before applying power. Confirm every 3.3 V, 5 V, ground, GPIO, SPI, I2S, and LED connection.

A USB-A to USB-C cable is recommended for the current enclosure power connection. The simple USB-C power board does not perform full USB-C current negotiation, so some USB-C to USB-C supplies may not power it correctly.

Do not power the clock through the Raspberry Pi and an external 5 V input at the same time.

---

## Prepare Raspberry Pi OS

Use Raspberry Pi Imager to configure the following before writing the microSD card:

- hostname
- Wi-Fi network and password
- Linux username and password
- SSH, when remote access is required
- timezone

For Calgary and Edmonton time:

```bash
sudo timedatectl set-timezone America/Edmonton
sudo timedatectl set-ntp true
```

Confirm synchronization:

```bash
timedatectl status
timedatectl show -p NTPSynchronized
```

Expected values include:

```text
System clock synchronized: yes
NTP service: active
NTPSynchronized=yes
```

mk-piclock uses the Linux system clock and does not contact an NTP server directly.

> [!NOTE]
> The clock has no battery-backed real-time clock. Correct time after a power loss depends on Linux restoring time and reaching a network time source.

---

## Install dependencies

```bash
sudo apt update
sudo apt install --no-install-recommends -y \
  build-essential \
  pkg-config \
  libgpiod-dev \
  libpng-dev \
  libfreetype-dev \
  libasound2-dev \
  libmpg123-dev \
  libmp3lame-dev \
  libmicrohttpd-dev \
  fonts-dejavu \
  unzip
```

Confirm libgpiod 2.x:

```bash
pkg-config --modversion libgpiod
```

---

## Configure the hardware

Raspberry Pi OS Lite based on Debian 13 stores boot configuration in `/boot/firmware/config.txt`.

Back up and edit the file:

```bash
sudo cp /boot/firmware/config.txt \
  /boot/firmware/config.txt.mk-piclock-backup
sudo nano /boot/firmware/config.txt
```

Add these settings under the existing `[all]` section:

```ini
# mk-piclock hardware

# SSD1322 OLED on SPI0
dtparam=spi=on

# Disable the Pi analogue audio device
dtparam=audio=off

# MAX98357A I2S amplifier
dtoverlay=max98357a,no-sdmode

# Reduce memory reserved for legacy GPU functions
gpu_mem=16
```

> [!IMPORTANT]
> Do not add another `[all]` heading. Each setting should appear only once.

No changes to `/boot/firmware/cmdline.txt` are required.

Reboot:

```bash
sudo reboot
```

---

## Verify the hardware

After rebooting, verify SPI, GPIO, and ALSA:

```bash
ls -l /dev/spidev0.0 /dev/gpiochip0
cat /proc/asound/cards
cat /proc/asound/pcm
```

The ALSA output should contain an I2S playback device. Its exact name can vary by kernel version.

### GPIO assignments

| Device | BCM GPIO | Physical pin |
|:--|--:|--:|
| OLED SPI clock | GPIO11 | 23 |
| OLED SPI data | GPIO10 | 19 |
| OLED chip select | GPIO8 | 24 |
| OLED D/C | GPIO25 | 22 |
| OLED reset | GPIO27 | 13 |
| Touch sensor output | GPIO20 | 38 |
| RGB LED red | GPIO5 | 29 |
| RGB LED green | GPIO6 | 31 |
| RGB LED blue | GPIO13 | 33 |

See `pinouts.md` for complete OLED, amplifier, speaker, touch, RGB LED, and power wiring.

---

## Extract, build, and install

Place the release ZIP and `.sha256` file in the same directory, then run:

```bash
cd ~
sha256sum -c mk-piclock-v1.9.14-rpi-zero-r3-release.zip.sha256
rm -rf mk-piclock-v1.9.14-rpi-zero-r3
unzip mk-piclock-v1.9.14-rpi-zero-r3-release.zip
cd mk-piclock-v1.9.14-rpi-zero-r3
```

A successful checksum test reports:

```text
mk-piclock-v1.9.14-rpi-zero-r3-release.zip: OK
```

Use the build command for the installed Pi:

| Raspberry Pi | Build command |
|:--|:--|
| Zero W | `make clean && make -j1` |
| Zero 2 W | `make clean && make -j2` |

Confirm both binaries exist:

```bash
ls -lh mk-piclock-core mk-piclock-api
```

Do not continue if either binary is missing.

Install and restart both services:

```bash
make install
sudo systemctl restart \
  mk-piclock-core.service \
  mk-piclock-api.service
sudo systemctl --no-pager --full status \
  mk-piclock-core.service \
  mk-piclock-api.service
```

> [!IMPORTANT]
> Do not run `sudo make install`. The Makefile uses `sudo` only where required.

Both services should report:

```text
Active: active (running)
```

The installer creates restricted service accounts, installs the programs and web interface under `/opt/mk-piclock`, configures systemd, grants required hardware access, and preserves existing configuration and uploaded media during upgrades.

---

## Open and configure the clock

### Find the address

Hold the touch sensor to open OLED network diagnostics. It shows the Wi-Fi network, signal strength, IP address, and hostname. Tap to close it, or allow it to close automatically.

From Linux, run:

```bash
hostname -I
```

Open the clock in a browser:

```text
http://<clock-ip>:8080/
```

Example:

```text
http://192.168.1.42:8080/
```

### Web password

When no web password is configured, the controls open directly. Set, change, or remove the password under **System**.

The password is stored as plain text on the clock. Keep port `8080` on a trusted local network and do not expose it to the internet.

### Initial setup

1. Under **Display**, set the clock name, time format, font, brightness, bedtime schedule, and browser preview colour.
2. Upload artwork under **Day Images** and **Bedtime Images**.
3. Upload songs under **Music** and MP3 stories under **Stories**.
4. Configure alarms, Story Mode, and its intro text.
5. Under **Lighting**, configure the six activity profiles and test each RGB channel.
6. Under **System**, confirm network, NTP, storage, OLED, touch, and service health.
7. Set an optional web password and download an initial backup.

### Touch controls

| Action | Result |
|:--|:--|
| Tap during an alarm | Dismiss the alarm |
| Tap during music or a story | Stop playback |
| Hold, then release | Play a random song |
| Keep holding | Open network diagnostics |
| Tap ten times during the Story Mode window | Play a random story when Story Mode is enabled |

Opening diagnostics does not start music and does not count toward Story Mode.

OLED messages can optionally play the built-in chime. The chime is skipped when other audio is playing.

Browser save, test, upload, and delete results appear in a floating notice that remains visible while scrolling.

---

## Upgrade an existing clock

Before a major upgrade, use **System > Download Backup**.

The built-in backup excludes uploaded music and stories. Copy them separately when required:

```bash
sudo cp -a /opt/mk-piclock/assets/music ~/mk-piclock-music-backup
sudo cp -a /opt/mk-piclock/assets/stories ~/mk-piclock-stories-backup
```

Build and install the new release using the same steps as a new installation:

```bash
cd ~/mk-piclock-v1.9.14-rpi-zero-r3
make clean
make -j2
make install
sudo systemctl restart \
  mk-piclock-core.service \
  mk-piclock-api.service
```

Use `make -j1` on a Pi Zero W.

An upgrade replaces the binaries, web interface, service files, default alarm, message chime, and API document. It preserves clock configuration, alarms, uploaded images, music, stories, fonts, lighting settings, and the optional web password.

Confirm the versions under **System**:

```text
Product:     1.9.14-rpi-zero-r3
HTTP API:    1.26
Private IPC: 16
```

The core, API, and browser interface must all come from the same release. After an upgrade, hard-refresh the browser.

---

## Reset a lost web password

You need the Raspberry Pi Linux account password to use `sudo`.

Connect through SSH or use a local terminal, then run:

```bash
sudo systemctl stop mk-piclock-api.service
sudo rm -f \
  /opt/mk-piclock/config/web-password.txt \
  /opt/mk-piclock/config/.web-password.tmp
sudo systemctl start mk-piclock-api.service
sudo systemctl --no-pager --full status mk-piclock-api.service
```

Reload `http://<clock-ip>:8080/`. The prompt will be removed. Set a new password under **System**, or leave it blank.

This resets only the mk-piclock web password. It does not change the Linux login or remove settings, alarms, media, or backups.

---

## Service control and logs

### Status

```bash
sudo systemctl --no-pager --full status \
  mk-piclock-core.service \
  mk-piclock-api.service
```

### Restart

```bash
sudo systemctl restart \
  mk-piclock-core.service \
  mk-piclock-api.service
```

### Recent logs

```bash
sudo journalctl -b -u mk-piclock-core.service -n 100 --no-pager
sudo journalctl -b -u mk-piclock-api.service -n 100 --no-pager
```

### Follow both logs

```bash
sudo journalctl -f \
  -u mk-piclock-core.service \
  -u mk-piclock-api.service
```

---

## Storage locations

| Purpose | Path |
|:--|:--|
| Core binary | `/opt/mk-piclock/mk-piclock-core` |
| API binary | `/opt/mk-piclock/mk-piclock-api` |
| Day Images | `/opt/mk-piclock/assets/images` |
| Bedtime Images | `/opt/mk-piclock/assets/bedtime-images` |
| Music | `/opt/mk-piclock/assets/music` |
| Music processing | `/opt/mk-piclock/assets/music/.processing` |
| Stories | `/opt/mk-piclock/assets/stories` |
| Fonts | `/opt/mk-piclock/assets/fonts` |
| Default alarm | `/opt/mk-piclock/assets/default-alarm.mp3` |
| Message chime | `/opt/mk-piclock/assets/message-chime.mp3` |
| Clock configuration | `/opt/mk-piclock/config/clock.conf` |
| Optional web password | `/opt/mk-piclock/config/web-password.txt` |
| Event log | `/opt/mk-piclock/config/event.log` |
| Web interface | `/opt/mk-piclock/web` |
| OpenAPI document | `/opt/mk-piclock/api/openapi-v1.json` |
| Private core socket | `/run/mk-piclock/core.sock` |

The old `auth`, `faces`, `bedtime-faces`, and `bedtime_faces` directories are not used.

---

## Troubleshooting

### Web interface does not open

```bash
sudo systemctl restart mk-piclock-core mk-piclock-api
sudo systemctl --no-pager --full status mk-piclock-api
sudo journalctl -b -u mk-piclock-api -n 100 --no-pager
hostname -I
```

Confirm that port `8080` is reachable from the local network.

### API version mismatch

Rebuild and reinstall the complete release, restart both services, then hard-refresh the browser. Do not replace only one binary.

### OLED is blank

```bash
ls -l /dev/spidev0.0 /dev/gpiochip0
id mk-piclock-core
sudo journalctl -b -u mk-piclock-core -n 100 --no-pager
```

Confirm that:

- SPI is enabled
- wiring matches `pinouts.md`
- OLED power is 3.3 V where specified
- D/C, reset, and chip-select pins are correct
- `mk-piclock-core` belongs to the `spi` and `gpio` groups

### No sound

```bash
cat /proc/asound/cards
cat /proc/asound/pcm
id mk-piclock-core
sudo journalctl -b -u mk-piclock-core.service -n 100 --no-pager
```

Confirm that:

- `dtoverlay=max98357a,no-sdmode` is active
- the amplifier uses the Pi I2S pins
- the speaker is connected to the amplifier output
- the amplifier SD/EN input is not holding the board disabled
- `mk-piclock-core` belongs to the `audio` group

### Touch does not respond

Confirm that the TTP223B output is connected to BCM GPIO20, physical pin 38, then follow the core log while touching the sensor:

```bash
sudo journalctl -f -u mk-piclock-core.service
```

### Network diagnostics shows unavailable values

SSID or signal values can be unavailable when Wi-Fi is disconnected or the Linux driver does not expose them.

### Wrong time after startup

```bash
sudo timedatectl set-timezone America/Edmonton
sudo timedatectl set-ntp true
timedatectl status
```

Allow the Pi to connect to Wi-Fi and synchronize.

### Missing build header

Rerun the dependency installation command, then rebuild with `make -j1` on a Zero W or `make -j2` on a Zero 2 W.

### Clock skew or future-dated source files

Synchronize the Pi clock:

```bash
sudo timedatectl set-ntp true
sudo systemctl restart systemd-timesyncd
timedatectl status
```

To normalize an extracted source tree:

```bash
find . -type f -exec touch {} +
make clean
make -j2
```

Use `make -j1` on a Pi Zero W.

### Re-add existing image assets

Upload original PNG files through **Day Images** and **Bedtime Images**. The API keeps the PNG and creates a matching 128x64, 8-bit grayscale `.raw` file. A 2:1 PNG is recommended so the full composition survives the clock crop. Final 4-bit quantization occurs after cropping and resizing for the active layout.

Older 64x64 RAW8 and packed RAW4 files are unsupported. Before upgrading, delete old Day Images and Bedtime Images through the GUI, then upload the PNG artwork again.

Each converted image requires matching base names:

```text
example.png
example.raw
```

After copying files manually, restore ownership and permissions, then restart both services:

```bash
sudo chown -R mk-piclock-api:mk-piclock /opt/mk-piclock/assets
sudo chmod -R u=rwX,g=rX,o= /opt/mk-piclock/assets
sudo systemctl restart mk-piclock-core mk-piclock-api
```

A PNG without its `.raw` partner does not appear in the OLED rotation.

---

## Related documentation

| Document | Purpose |
|:--|:--|
| `README.md` | Features and normal use |
| `pinouts.md` | Complete hardware wiring |
| `CHANGELOG.md` | Version history |
| `RELEASE_NOTES.md` | Current release changes |
| `ADDON_API.md` | HTTP API details |
| `api/openapi-v1.json` | OpenAPI schema |
