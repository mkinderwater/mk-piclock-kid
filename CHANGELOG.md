# Changelog

## 1.9.17-rpi-zero-r3 - 2026-08-04

### Web module context cleanup

- Removed the unused `$$` multi-element query helper from `app.js`.
- Stopped exposing `$$` in the shared context supplied to all 11 GUI modules.
- Preserved each module's existing direct, scoped `querySelectorAll(...)` usage.
- Made no API or GUI behaviour changes.

## 1.9.16-rpi-zero-r3 - 2026-08-04

### Story Mode network diagnostics access

- Allowed the eight-second touch hold to open OLED network diagnostics while music or a story is playing.
- Preserved a continuous diagnostic hold that begins during the Story Mode intro or title.
- Kept short or incomplete intro-time presses suppressed so they cannot stop the story or start random music.
- Continued audio playback behind the diagnostic screen.
- Preserved alarm priority: an active alarm must be dismissed before diagnostics can open.

## 1.9.15-rpi-zero-r3 - 2026-07-27

### Immediate alarm-footer refresh

- Marked the OLED clock display dirty whenever an alarm is saved.
- Turning the final enabled alarm off now removes the `ALARM` footer on the next display loop instead of waiting for the next minute redraw.
- Alarm enable, time, and weekday changes now refresh the next-alarm footer immediately.

## 1.9.14-rpi-zero-r3 - 2026-07-24

### Full-size artwork with compact message text

- Restored sent-message artwork to the normal 96x48 clock viewport.
- Preserved the 2:1 ratio and X=2 alignment with the `ALARM` label.
- Added a dedicated 144x48 message text viewport at X=106, Y=8.
- Reduced message TrueType text to an independent 9px through 12px range.
- Reduced built-in fallback message text from scale 2 to scale 1.
- Added text-height validation to match the compact viewport.
- Kept the exact browser preview and physical OLED on the same renderer.
- Left Day Images and Bedtime Images GUI previews unchanged.

## 1.9.13-rpi-zero-r3 - 2026-07-24

### Half-size message artwork

- Reduced sent-message artwork from 64x32 to 32x16.
- Preserved the 2:1 ratio and X=2 alignment with the `ALARM` label.
- Vertically centred the smaller artwork at Y=24.
- Moved message text to X=38 and increased its usable width to 214 pixels.
- Left normal clock artwork and Day Images and Bedtime Images GUI previews unchanged.

## 1.9.12-rpi-zero-r3 - 2026-07-24

### Message display regression fix

- Corrected the message artwork viewport to 64x32, preserving the established message text area.
- Keeps the current 2:1 artwork ratio without cropping or distortion.
- Vertically centres message artwork and aligns its first pixel with the `ALARM` label at X=2.
- Restores message preview validation and sending for text that fit before v1.9.11.
- Retains 2:1 Day Images and Bedtime Images previews in the GUI.

## 1.9.11-rpi-zero-r3 - 2026-07-24

### Image layout completion

- Updated message screens from the old 64x64 picture block to the current 96x48, 2:1 clock artwork geometry.
- Aligned message and normal-clock artwork to the same X=2 pixel used by the `ALARM` footer label.
- Expanded the message text region to the shared two-pixel right edge after the resized image and six-pixel gap.
- Changed Day Images and Bedtime Images cards from square thumbnails to accurate 2:1 previews.
- Advanced the product and GUI cache identity to `1.9.11-rpi-zero-r3`.
- Retained HTTP API 1.26 and private IPC 16.

## 1.9.10-rpi-zero-r3 - 2026-07-24

### Persistent alarm replay protection

- Persisted each alarm's last-fired local date before playback starts.
- Prevented an alarm interrupted by power loss or a service restart from replaying later on the same date.
- Migrated the existing `last_successful_alarm` timestamp into matching alarm slots on first startup.
- Preserved the replay guard when only volume, music, or enabled state changes.
- Reset the guard when an alarm's time or weekday schedule changes.
- Retained the confirmed flicker-free OLED renderer from R2.
- Updated startup, API, diagnostics, logs, web cache, installation guide, and release identity to `1.9.10-rpi-zero-r3`.
- Retained HTTP API 1.26 and private IPC 16.

### Isolated once-per-second OLED updates

- Removed the complete clock compositor from the once-per-second update path.
- Added cached colon-on and colon-off clock layers.
- Each second changes only cached colon bytes and the seconds-line gap.
- The image framebuffer is not cleared, regenerated, rescaled, dithered, or rewritten on second ticks.
- Changed music marquee updates to use the shared dirty-framebuffer flush instead of a forced full-width footer transfer.
- Prevented unrelated adjacent dirty rows from expanding into one wide transfer rectangle.

## 1.9.9-rpi-zero-r2

- Replaced the clock screen's full OLED refresh with framebuffer-based dirty row bands.
- The blinking colon and seconds position line now update independently without rewriting unchanged clock artwork.
- Full-screen transfers remain available for startup, screen changes, brightness changes, and actual image changes.
- Kept HTTP API at 1.26 and private IPC at 16.

## 1.9.8-rpi-zero-r2

- Removed the legacy 64x64 RAW8 and packed RAW4 image loaders.
- Clock artwork now accepts only the canonical 128x64 RAW8 source generated by a new PNG upload.
- Old image libraries must be deleted and uploaded again after upgrading.
- Reduced the image-format checks and load path to one exact file size.
- Advanced the Raspberry Pi release identity and GUI cache revision.


## 1.9.7-rpi-zero-r2

- Added `SPEAKER_POP_NOISE.md`.
- Documented the Raspberry Pi MAX98357A start and stop click mechanism.
- Recorded GPIO4, physical pin 7, SD/EN testing and observed mute behaviour.
- Documented a possible custom-overlay and resistor-controlled SD_MODE solution.
- Explained why the Banana Pi overlay avoids the same pop through managed SD/EN, a 5 ms delay, and stable two-slot I2S framing.

## v1.9.7-rpi-zero-r2 - 2026-07-24

### Raspberry Pi build identity

- Added the same hardware-profile product identity used by the Banana Pi build.
- The startup greeting now shows `v1.9.7-rpi-zero-r2` in the lower-right corner.
- Product version, API diagnostics, logs, and web assets now use the same Raspberry Pi build identifier.
- Identifies the supported Raspberry Pi Zero W and Zero 2 W platform as `Raspberry Pi Zero`.
- Preserved the full-width music footer changes from v1.9.6.
- Kept HTTP API at 1.26 and private IPC at 16.

## v1.9.6 - 2026-07-24

### Full-width music footer

- Removed the vertical separator after the alarm notice.
- Removed the `ALARM OFF` notice when no future alarm is scheduled.
- Hid all alarm notices while music is playing so metadata and its marquee can use the footer from X=2 through X=253.
- Kept the date right-aligned to the shared X=253 edge when song metadata is not shown.
- Kept HTTP API at 1.26 and private IPC at 16.

## v1.9.5 - 2026-07-17

### Fixed-position clock release

- Promoted the corrected fixed-slot clock renderer as the v1.9.5 release.
- Kept one clock origin for every minute value, including proportional and uploaded TrueType/OpenType fonts.
- Right-aligned each numeric glyph inside its reserved slot while keeping the colon centred.
- Kept the final visible minute pixel aligned to X=253 with the date and music metadata.
- Preserved the 64x48 safe image region and 8-bit grayscale RAW image pipeline.
- Kept HTTP API at 1.26 and private IPC at 16.

## v1.8.4 - 2026-07-17

### Font-independent clock anchoring

- Replaced direct TrueType glyph placement with a fixed-slot off-screen clock canvas.
- Measured visible glyph ink after OLED coverage quantization rather than relying on advance widths or bearings.
- Anchored the final minute digit's last visible pixel to X=253, matching the date and music metadata edge.
- Kept slot origins fixed so changing minute digits cannot move the complete clock.
- Corrected the renderer so it anchors the fixed slot grid itself, rather than re-aligning that grid from the current minute digit's width.
- Right-anchored numeric glyphs inside their slots while keeping the colon centred, preserving one clock origin for every minute value.
- Added clean fallback when a selected font lacks a required digit or colon.
- Added a safe 64x48 image region for the 24-hour clock layout with two-pixel margins from screen edges, the seconds line, and clock ink.
- Changed new image assets to 8-bit grayscale RAW sources and delayed OLED 4-bit quantization until after the final crop and resize.
- Added high-quality PNG downsampling, bilinear display scaling, and stable ordered dithering.
- Preserved compatibility with packed 4-bit RAW image assets from earlier releases.
- Kept HTTP API at 1.26 and private IPC at 16.

## v1.8.3 - 2026-07-17

### Footer alignment

- Raised the alarm label and shared date/music footer baseline by one OLED pixel.
- Locked the TrueType clock to a fixed slot origin so minute changes cannot shift the full clock left or right.
- Anchored the final visible clock pixel, date, and song metadata to the same X coordinate with matching two-pixel outer padding.
- Matched the alarm label padding: two pixels from the left edge and two pixels before the dynamic separator.
- Preserved the full-height dynamic separator and unified OLED line brightness.
- Promoted the finalized GUI and packaging cleanup as the v1.8.3 release.
- Kept HTTP API at 1.26 and private IPC at 16.

## v1.8.2 - 2026-07-17

### Release polish

- Matched the dynamic vertical footer separator to the horizontal seconds line using the same OLED brightness constant.
- Kept the separator intersecting the horizontal line at its dynamically calculated position.
- Finalized runtime Linux font discovery, uploaded-font precedence, and DejaVu Sans Mono fallback behaviour.
- Added the exact `sudo apt-get install fonts-dejavu` command to the installation guide.
- Packaged the build as the clean v1.8.2 release.
- Removed the standalone divider between RGB Lighting and Global Controls; standard card spacing now separates them.
- Rebuilt the master stylesheet as one canonical design system and removed repeated legacy declarations.
- Removed non-header separators from System forms and image-library upload sections.
- Standardized warning cards, card headers, controls, buttons, status tiles, tables, details panels, empty states, and mobile actions across every GUI page.
- Reserved red danger buttons for destructive actions.
- Advanced the GUI cache revision to 1.8.2-r2.
- Kept HTTP API at 1.26 and private IPC at 16.

## v1.8.1 - 2026-07-17

### Display and GUI polish

- Removed the OLED Wi-Fi footer status and its polling path; network details remain in diagnostics.
- Changed the alarm footer to show the next scheduled time, such as `ALARM 6:00AM`, or `ALARM OFF`.
- Added a dynamically positioned vertical pixel separator after the alarm label that intersects the footer top line.
- Right-aligned song metadata to the exact date edge and retained marquee scrolling for long titles.
- Set DejaVu Sans Mono as the default clock font through the standard Linux font package.
- Use an uploaded font before the DejaVu default; deleting it selects another upload when available, then falls back to DejaVu Sans Mono.
- Removed special system-font ordering; installed fonts are listed alphabetically.
- Standardized every GUI card heading with the same divider, spacing, and title alignment.
- Changed inactive sound status from `Quiet` to `None` across the GUI.
- Added a visible divider and dedicated spacing between RGB Lighting and Global Controls.
- Replaced the two-stage font controls with one Clock font selector that lists built-in, installed Linux, and uploaded fonts together.
- Added runtime scanning of `/usr/share/fonts` and `/usr/local/share/fonts` whenever the Display page loads.
- Removed the duplicate divider beneath the Web password description.
- Added matching headings to Story playback and Activity history.
- Updated browser asset identifiers to prevent stale cached files.
- Advanced HTTP API to 1.26; private IPC remains 16.

## v1.8.0 - 2026-07-17

### Production display and code cleanup

- Removed the obsolete OLED Wi-Fi and alarm pill renderer, geometry helpers, and icon routines.
- Replaced the old pill footer with a compact text status footer.
- Right-aligned the time and date to the same fixed display edge.
- Restored the permanent one-pixel separator with a moving black seconds position.
- Removed the redundant `trim_ascii_line()` and `read_first_line_from_file()` helpers.
- Added `-Werror=unused-function` and `-Werror=implicit-function-declaration` to both native builds.
- Removed the unnecessary `gpiod` command-line package from the documented dependency list.
- Audited all C translation units and browser modules; no other unreferenced functions were found.
- Kept HTTP API at 1.25 and private IPC at 16.

## v1.7.6 - 2026-07-10

### Clean OLED network diagnostics

- Removed unsupported parentheses from the OLED Wi-Fi signal line.
- Changed the signal display from `75% (-62 dBm)` to `75% -62 dBm` so every character exists in the built-in 5x7 font.
- Simplified README instructions to say that holding the touch sensor opens network diagnostics, without exposing the internal threshold.
- Kept the music, diagnostics, and Story Mode gesture logic unchanged.
- Kept HTTP API at 1.25 and private IPC at 16.

## v1.7.5 - 2026-07-10

### Safer diagnostics gesture and complete feature documentation

- Increased the OLED network diagnostic hold from six seconds to eight seconds.
- Kept random music on release after a three-second hold, provided the sensor is released before diagnostics opens.
- Kept diagnostic holds separate from the 10-tap Story Mode gesture.
- Expanded README coverage for the optional password, message chime, OLED diagnostics, floating GUI confirmations, and OLED metadata filtering.
- Kept HTTP API at 1.25 and private IPC at 16.

## v1.7.4 - 2026-07-10

### Clean OLED song metadata

- Filtered song titles and artists against the exact built-in 5x7 OLED glyph set.
- Omitted unsupported Unicode, emoji, symbols, and malformed characters instead of rendering fallback question marks.
- Filtered title and artist separately before assembling the OLED display line.
- Collapsed repeated spaces and removed leading or trailing spaces.
- Preserved the original metadata for the status API and web GUI.
- Kept HTTP API at 1.25 and private IPC at 16.

## v1.7.3 - 2026-07-10

### Optional password, message chime, OLED diagnostics, and floating confirmations

- Added a simple optional plaintext password for the web GUI and API.
- Added conditional login, session-cookie handling, and password controls on System.
- Added an optional built-in chime for immediate, delayed, and scheduled messages.
- Added a six-second touch hold for an OLED network diagnostic screen showing SSID, signal, IP address, and hostname.
- Changed the three-second music gesture to start on release so a six-second hold cannot trigger music first.
- Kept the diagnostic gesture separate from the 10-tap Story Mode gesture.
- Changed browser acknowledgments to a fixed floating notice visible from any scroll position.
- Increased HTTP API to 1.25 and private IPC to 16.

## v1.7.2 - 2026-07-07

### Story Mode intro display fix

- Kept the Story Mode intro splash visible for its full startup window even if the audio thread exits quickly.
- Added `story_intro_active` to `/api/v1/status` so the web GUI can report the intro state directly.
- Updated the Stories and Dashboard pages to show the configured intro message during startup instead of briefly flashing generic status text.
- Kept HTTP API at 1.24 and private IPC at 15.

## v1.7.1 - 2026-07-07

### MP3 queue cleanup

- Replaced the per-file queue loop with the cleaner atomic batch queue.
- Validated and staged the full MP3 selection before queueing any jobs.
- Rolled back staged source files if the batch cannot be queued.
- Kept upload blocking while any music job is queued or processing.
- Added selected-song count and total-size feedback on the Music page.
- Kept HTTP API at 1.24 and private IPC at 15.

## v1.7.0 - 2026-07-07

### Touch lighting and batch music uploads

- Added a high-priority touch lighting scene so pressing the TTP223B sensor blinks the RGB LED.
- Added Global Lighting controls for touch blink enable, colour, and brightness. Default is a white blink.
- Allowed one MP3 upload request to contain a batch of files.
- Kept new MP3 uploads blocked until all queued and processing music jobs are complete.
- Audited installer and runtime directory creation; no obsolete or unused directories are created.
- Increased HTTP API to 1.24 and kept private IPC at 15.

## v1.6.57 - 2026-07-05

### RGB lighting stability

- Replaced leading-edge PWM with trailing-edge PWM so late low-brightness pulses are skipped rather than stretched.
- Removed temporal dithering that caused visible low-level brightness modulation.
- Added stable 32-level output quantization.
- Added modest real-time scheduling for only the LED timing thread through `LimitRTPRIO`.
- Kept the HTTP API at 1.23 and private IPC at 15.

## v1.6.56 - 2026-07-05

### RGB lighting reliability and control

- Fixed the LED scene race between the control thread and renderer.
- Added batched GPIO writes, error counting, and automatic shutdown after repeated write failures.
- Added 200 Hz, 32-level PWM with temporal dithering and zero-output sleeping.
- Added linear-light fades, calibrated RGB gains, and 350 ms scene crossfades.
- Added a master switch, global brightness ceiling, idle-off mode, and gradual bedtime dimming.
- Added configurable effect-cycle timing, per-profile reset controls, and RGB wiring tests.
- Split intended LED colour from calibrated output in status and diagnostics.
- Revised bedroom defaults to reduce glare.
- Increased HTTP API to 1.23 and private IPC to 15.

## v1.6.55 - 2026-06-28

### RGB activity lighting

- Added six persistent LED profiles for Alarm, Bedtime, Message, Music, Daytime, and Stories.
- Added solid colour, two-colour fade, rainbow, and 0% to 100% brightness controls.
- Added common-cathode software PWM on GPIO5, GPIO6, and GPIO13.
- Added a Lighting GUI page with ten-second hardware previews.
- Connected Stories lighting to the existing `story_playing` runtime state.
- Added strict activity priority: Alarm, Message, Stories, Music, Bedtime, Daytime.
- Prevented previews from overriding an active alarm.
- Added LED status and profile data to `/api/v1/status`.
- Added `/api/v1/config/led` and `/api/v1/led/preview`.
- Increased HTTP API to 1.22 and private IPC to 14.

## v1.6.54 - 2026-06-24

### Dead-code cleanup

- Removed the obsolete `include_music` rollback switch and its restore compatibility branches.
- Replaced mixed restore/reset flags with explicit Restore and Factory Reset asset sets.
- Removed discarded ZIP entry-count outputs from image downloads and full backups.
- Removed the duplicate image-library ZIP central-directory writer and reused the shared ZIP finalizer.
- Removed the generic restore parent-directory parser; restore staging now creates only the known supported directories.
- Replaced the remaining recursive `PATH_MAX` cleanup routine with descriptor-based `openat()` and `unlinkat()` traversal.
- Consolidated flat asset move, clear, rollback, and staging logic.
- Kept HTTP API 1.21 and private IPC 13 unchanged.

## v1.6.53 - 2026-06-24

### API and backup hardening

- Replaced recursive `PATH_MAX` stack buffers with descriptor-based traversal using `openat()`, `fdopendir()`, and `fstatat()`.
- Kept the 32-level directory guard while reducing per-level stack use and refusing symlink traversal.
- Replaced the bit-at-a-time CRC32 loop with a thread-safe table implementation.
- Kept CRC32 portable across Raspberry Pi Zero, Zero 2 W, and Pi 5 builds instead of requiring ARMv8 CRC instructions.
- Changed ZIP DOS timestamps to UTC for deterministic backup metadata across timezone and daylight-saving changes.
- Added explicit `INT_MIN` and `INT_MAX` validation before converting parsed JSON integers to `int`.
- Kept HTTP API 1.21 and private IPC 13 unchanged.

## v1.6.52 - 2026-06-24

- Ignored all touch-sensor input during the Story Mode intro and title sequence.
- Cleared the ten-tap counter while touch input was locked.
- Hid the Wi-Fi and alarm status pills for the full duration of story playback.
- Restored the pills automatically when the story stopped or finished.
- Kept the normal Wi-Fi and alarm pill design unchanged outside Story Mode.

## v1.6.51 - 2026-06-24

- Removed the unused `collect_music_files()` helper that caused `-Wunused-function`.
- Folded the single-use audio-directory collector into the shared playable-library selector.
- Removed the unused `story_mode` field from the playback-thread request structure.
- Kept Story Mode behaviour, HTTP API 1.21, and private IPC 13 unchanged.

## v1.6.50 - 2026-06-24

- Added Story Mode with a separate Stories MP3 library.
- Added a ten-tap touch gesture completed within eight seconds.
- Added an independent story volume and parent enable switch.
- Added a configurable `STORY MODE!` OLED intro message.
- Added a random Bedtime Images collage for each story start.
- Added a timed story title display before the OLED returns to the normal clock.
- Added story upload, list, play, stop, delete, and delete-all API routes.
- Added story storage size and file count to System diagnostics.
- Excluded stories from backup and restore.
- Increased the HTTP API to 1.21 and private IPC to 13.

## v1.6.49 - 2026-06-24

### Build correction

- Removed the GCC `-Wformat-truncation` warning in Inventory ID generation.
- Replaced the variable `%s` write with an explicit bounded copy.
- Preserved the Inventory ID format and device-identity behaviour.
- Kept HTTP API version 1.20 because the API schema is unchanged.

## v1.6.48 - 2026-06-24

### Device identity

- Added a short Inventory ID derived from the Raspberry Pi board serial.
- Added the full Raspberry Pi serial to the System page, diagnostics API, and downloadable report.
- Added Raspberry Pi board revision and the operating-system machine ID.
- Added a CPU signature for processor identification and marked it as non-unique.
- Increased the HTTP API version to 1.20.

## v1.6.47 - 2026-06-24

### System identification

- Added the installed release version to the System page.
- Added the HTTP API version and API compile date and time.
- Added the same build information to the downloadable diagnostic report.

### Storage usage

- Split root filesystem storage into used, available, and total values.
- Added percentage used to the System page.
- Added directory sizes and file counts for Day Images, Bedtime Images, music, and fonts.
- Kept storage inspection in-process without external commands.

## v1.6.46 - 2026-06-24

- Corrected the earlier sidebar interpretation.
- Removed the blue vertical active-item bar from the desktop left navigation.
- Kept the active item background and text colour.
- Restored the standard pointer cursor for sidebar links.
- Left the clock-name hover behaviour unchanged.

# mk-piclock Changelog

This file records user-visible changes to the native C release.

## v1.6.45 - 2026-06-24

### Backup scope cleanup

- Removed all music-entry handling from restore.
- Removed the unused music-file allowance from backup creation.
- Backup and restore now contain no music processing, validation, extraction, or staging logic.
- Backups remain limited to configuration, Day Images, Bedtime Images, and fonts.

## v1.6.43 - 2026-06-24

### Backup scope

- Removed uploaded music from backup ZIP files.
- Left the existing music library untouched during restore.
- Allowed restore while music is queued or processing because restore does not touch music.
- Kept factory reset behaviour unchanged, including deletion of uploaded music.

### Header cleanup

- Removed the clock-name hover hint. This was reverted in v1.6.45.
- Replaced the text-selection cursor over the clock name with the normal cursor.
- Prevented accidental selection of the header clock name.

## v1.6.42 - 2026-06-24

### Build correction

- Removed the GCC `-Wformat-truncation` warning in storage device-path resolution.
- Added an explicit destination-size check before constructing `/dev/<device>`.
- Preserved the command-free runtime and existing diagnostic behaviour.

## v1.6.41 - 2026-06-24

### Network diagnostics

- Replaced `getifaddrs()` with direct IPv4 interface ioctls so network diagnostics work inside the restricted API service.
- Added default-route interface selection and a wireless-interface fallback.
- Corrected zero-percent Wi-Fi signal handling so a weak connection is not mistaken for missing data.
- Kept diagnostics command-free and retained the existing restricted address-family sandbox.

### Platform and storage diagnostics

- Added Raspberry Pi model, operating system, OS release, codename, kernel, architecture, and uptime.
- Added system drive, root partition, filesystem, read-only state, boot partition, boot filesystem, and boot mount point.
- Added inserted SD-card device, type, product name, capacity, manufacturer ID, OEM ID, serial, manufacture date, and CID.
- Expanded the downloadable diagnostic report with the same platform and storage details.
- Updated HTTP API to 1.18. Private IPC remains 12.

## v1.6.40 - 2026-06-24

### Alarm safety

- Changed alarms to loop until dismissed with the physical touch sensor.
- Rejected browser stop commands while an alarm is active.
- Added a protected built-in fallback MP3 for missing, unreadable, or invalid alarm music.
- Added a 30-minute maximum alarm duration.
- Recorded the last alarm that successfully started audio.
- Added next-alarm calculations and Home-page display.

### Bedtime controls

- Added a parent setting to disable manual music during bedtime.
- Blocked browser and touch-started music during the configured bedtime window.
- Stopped ordinary music automatically when bedtime begins.
- Kept scheduled alarms independent from the bedtime music restriction.

### System, backup, and diagnostics

- Added IP address, hostname, SSID, Wi-Fi signal, NTP state, CPU temperature, storage, API/core health, OLED health, and touch health.
- Added a Home-page time synchronization warning.
- Added a downloadable diagnostic report.
- Added complete backup download and validated restore.
- Added factory reset for settings and user-added assets.
- Protected reset and restore from active alarms and music processing.
- Updated HTTP API to 1.17 and private IPC to 12.

## v1.6.39 - 2026-06-23

### Complete static-asset cleanup

- Changed `make install` to stop the API before replacing web files.
- Replaced `/opt/mk-piclock/web` and `/opt/mk-piclock/api` as complete trees instead of deleting only visible children.
- Removed stale hidden files, retired modules, and superseded assets from prior installations.
- Changed every GUI resource, including icons and the favicon, to `Cache-Control: no-store`.
- Added v1.6.39 revision keys to the manifest, icons, module list, module HTML, CSS, and JavaScript.
- Removed the unused 48x48 favicon.
- Changed `make uninstall` to remove installed web and API documentation trees while preserving user images, music, fonts, and configuration.
- Kept HTTP API 1.16 and private IPC 11 unchanged.

## v1.6.38 - 2026-06-23

### GUI cache compatibility

- Fixed a false GUI/API mismatch where a cached v1.15 `app.js` rejected the running v1.16 API.
- Changed mutable GUI resources, including HTML, CSS, JavaScript, JSON, and manifests, to `Cache-Control: no-store`.
- Stopped returning `304 Not Modified` for no-store resources.
- Updated GUI asset revision URLs to v1.6.38 so browsers request the current files immediately after installation.
- Kept HTTP API 1.16 and private IPC 11 unchanged.

### Cause corrected

The GUI cache key had not changed when the required API moved from v1.15 to v1.16. The server also cached GUI files for one hour and generated ETags from file timestamp and size only. Because `1.15` and `1.16` have the same length, an old JavaScript file could remain valid in the browser even after the new API was installed.

## v1.6.37 - 2026-06-23

### Music queue reliability

- Limited MP3 upload to one file per request.
- Refused new uploads while any song is queued or processing.
- Added a browser-side queue check before upload.
- Added an atomic API-side busy check to prevent overlapping requests.
- Disabled upload controls while the worker is busy.
- Added **Clear Queue** for waiting uploads and their temporary source files.
- Kept the active transcode running when the waiting queue is cleared.
- Changed the processing view so the active job is listed before queued and completed jobs.
- Updated HTTP API to 1.16.

### Cause corrected

The previous uploader could start transcoding the first file while the same request was still validating and staging later files. It also accepted another upload while the worker was active. On a Raspberry Pi, this allowed concurrent MP3 decoding and heavy storage activity. Later items could remain displayed as **Queued**, while the older active item was hidden by the limited newest-first list.

## v1.6.36 - 2026-06-23

### Access-control cleanup

- Removed the final obsolete access-control path from the API systemd service.
- Removed old install and uninstall cleanup commands for the deleted auth directory.
- Removed historical access-control compatibility text from active documentation.
- Confirmed that no auth routes, auth source modules, password files, remembered-browser keys, or OpenAPI security definitions remained.
- Kept HTTP API 1.15 and private IPC 11 unchanged.

## v1.6.35 - 2026-06-23

### Direct local controls

- Removed the GUI login screen.
- Removed password requirements.
- Removed remembered-device handling.
- Removed browser session and local storage authentication state.
- Removed credential, lockout, recovery, and access-key logic.
- Removed all `/api/v1/auth/*` routes.
- Removed the Security page and sign-out controls.
- Removed `auth_store.c` and `auth_store.h`.
- Removed the `/opt/mk-piclock/auth` data directory.
- Made all GUI and API routes directly available on the trusted local network.
- Updated HTTP API to 1.15.

### Retained

- Restricted core and API system users
- Private Unix socket between services
- Day and Bedtime **Download All PNGs** actions
- Centered mK browser, Apple, Android, and GUI icons

## v1.6.34 - 2026-06-23

### Historical access-key fix

This release still contained the password system that was removed in v1.6.35.

- Corrected valid access keys being rejected immediately after login.
- Moved authentication evaluation until after libmicrohttpd request parsing.
- Retained stale-response protection.
- Simplified the old remembered-browser implementation.
- Added SSH password recovery instructions.
- Retained login throttling and PBKDF2-HMAC-SHA256 password storage.

### Image library downloads

- Added or retained **Download All Day PNGs**.
- Added or retained **Download All Bedtime PNGs**.
- Excluded converted OLED `.raw` files from download ZIPs.

### Icons

- Added centered mK favicon sizes.
- Added Apple touch and Android launcher icons.
- Used the centered mK artwork in the GUI header.

## Earlier v1.6 development - consolidated

The following work was completed throughout earlier v1.6 releases. Some intermediate builds were experimental and were replaced by later implementations.

### Native architecture

- Moved the clock to a native C core and native C HTTP API.
- Split hardware ownership from web and asset processing.
- Added private binary IPC over `/run/mk-piclock/core.sock`.
- Replaced legacy GPIO access with libgpiod 2.x.
- Added systemd services and restricted service accounts.
- Added service hardening and limited writable paths.

### OLED and clock rendering

- Added SSD1322 256x64 SPI support.
- Added chunked framebuffer writes for SPI transfer limits.
- Added a large centred clock, full date, and blinking colon.
- Added 12-hour and 24-hour modes.
- Added built-in and uploaded font selection.
- Added FreeType caching and grayscale gamma handling.
- Added Wi-Fi and alarm status indicators.
- Added rotating images beside the clock.
- Added separate day and bedtime image rotation.
- Added OLED panel colour selection for browser previews.
- Added live raw framebuffer display on the Home page.

### Alarms and audio

- Added seven configurable alarms.
- Added weekday schedules.
- Added specific or random wake-up music.
- Added per-alarm start and final volumes.
- Added song-length-based alarm volume ramping.
- Added MP3 playback with mpg123 and ALSA.
- Added global volume control.
- Added title and artist display.
- Added scrolling long metadata.
- Improved common accented Latin metadata handling.
- Added touch input: short press stops audio and a three-second hold plays random music.

### Messages

- Added immediate OLED messages.
- Added delayed messages.
- Added scheduled messages up to 30 days ahead.
- Added specific and random Day or Bedtime image selection.
- Added image-only messages.
- Added persistent pending-message state.
- Replaced approximate browser wrapping with core-rendered OLED previews.
- Centred message lines using actual rendered dimensions.

### Image libraries

- Separated Day Images and Bedtime Images.
- Added PNG validation and conversion to OLED raw assets.
- Added upload, review, pagination, individual deletion, and delete-all controls.
- Preserved original PNG files for browser display and download.
- Removed the older face-specific terminology from current storage paths and GUI labels.

### Music library

- Added MP3 validation and in-process LAME transcoding.
- Added a recommended mono profile for the MAX98357A and small speaker.
- Added processing progress and job history.
- Added music metadata inspection.
- Added play, stop, and delete controls.
- Reset alarms to Random when their selected file is deleted.

### Web GUI

- Reorganized controls around everyday tasks.
- Added Home, Alarms, Messages, Music, Day Images, Bedtime Images, Display, and Recent Activity pages.
- Added responsive phone and tablet layouts.
- Moved technical options into collapsed sections.
- Added API and GUI version compatibility checks.
- Added recent event-log viewing.
- Added network and uptime status.

### Installation and hardware documentation

- Standardized Raspberry Pi OS Lite Debian 13 Trixie instructions.
- Added SPI, MAX98357A, GPIO, OLED, touch, and power wiring documentation.
- Added `gpu_mem=16` configuration.
- Documented service verification and journal inspection.
- Documented image migration from older face directories.

## Compatibility table

| Product | HTTP API | Private IPC | Notes |
| --- | ---: | ---: | --- |
| 1.9.17-rpi-zero-r3 | 1.26 | 16 | Removed unused shared `$$` GUI query helper |
| 1.9.16-rpi-zero-r3 | 1.26 | 16 | Network diagnostics during Story Mode and audio playback |
| 1.9.15-rpi-zero-r3 | 1.26 | 16 | Immediate OLED alarm-footer refresh after alarm changes |
| 1.9.14-rpi-zero-r3 | 1.26 | 16 | Full-size 96x48 message artwork with compact 9px to 12px text |
| 1.9.13-rpi-zero-r3 | 1.26 | 16 | Half-size 32x16 message artwork with X=2 alignment |
| 1.9.12-rpi-zero-r3 | 1.26 | 16 | Restored message text geometry with 64x32 2:1 artwork and X=2 alignment |
| 1.9.11-rpi-zero-r3 | 1.26 | 16 | 96x48 message artwork, 2:1 GUI previews, and shared image alignment |
| 1.9.10-rpi-zero-r3 | 1.26 | 16 | Persistent alarm replay guard and isolated second-tick rendering |
| 1.9.9-rpi-zero-r2 | 1.26 | 16 | Dirty-band transfer attempt; superseded by isolated tick rendering |
| 1.9.8-rpi-zero-r2 | 1.26 | 16 | Canonical 128x64 RAW8 artwork only |
| 1.9.7-rpi-zero-r2 | 1.26 | 16 | Raspberry Pi build identity, music footer, and speaker-pop notes |
| 1.9.5 | 1.26 | 16 | Fixed-position clock and RAW8 image release |
| 1.8.4 | 1.26 | 16 | Font-independent clock anchoring and RAW8 images |
| 1.8.3 | 1.26 | 16 | Final footer alignment and release packaging |
| 1.8.2 | 1.26 | 16 | Final footer, font, and GUI release polish |
| 1.8.1 | 1.26 | 16 | GUI consistency and Linux font discovery |
| 1.8.0 | 1.25 | 16 | Production cleanup and warning prevention |
| 1.7.6 | 1.25 | 16 | Clean OLED network diagnostics |
| 1.7.5 | 1.25 | 16 | Eight-second diagnostics hold and complete README |
| 1.7.4 | 1.25 | 16 | OLED metadata glyph filtering |
| 1.7.3 | 1.25 | 16 | Optional password, message chime, OLED diagnostics, and floating notices |
| 1.7.2 | 1.24 | 15 | Story Mode intro display fix |
| 1.7.1 | 1.24 | 15 | Atomic batch MP3 queue cleanup |
| 1.7.0 | 1.24 | 15 | Touch lighting and batch MP3 uploads |
| 1.6.57 | 1.23 | 15 | Stable trailing-edge RGB PWM |
| 1.6.56 | 1.23 | 15 | Calibrated, hardened RGB lighting |
| 1.6.55 | 1.22 | 14 | Six-mode RGB activity lighting |
| 1.6.54 | 1.21 | 13 | Dead-code and restore-transaction cleanup |
| 1.6.53 | 1.21 | 13 | Embedded API and backup hardening |
| 1.6.51 | 1.21 | 13 | Story Mode cleanup and warning removal |
| 1.6.50 | 1.21 | 13 | Story Mode, separate story library, touch gesture, and OLED intro |
| 1.6.49 | 1.20 | 12 | Inventory ID warning correction |
| 1.6.48 | 1.20 | 12 | Raspberry Pi device identity |
| 1.6.47 | 1.19 | 12 | Release, build, storage, and asset usage diagnostics |
| 1.6.46 | 1.18 | 12 | Sidebar active-bar removal |
| 1.6.45 | 1.18 | 12 | Sidebar cursor correction |
| 1.6.44 | 1.18 | 12 | Backup and restore contain no music handling |
| 1.6.43 | 1.18 | 12 | Music-free backups and header hover cleanup |
| 1.6.42 | 1.18 | 12 | Storage path build-warning correction |
| 1.6.41 | 1.18 | 12 | Network, platform, and SD-card diagnostics |
| 1.6.40 | 1.17 | 12 | Alarm safety, backup, and system diagnostics |
| 1.6.39 | 1.16 | 11 | GUI cache and API compatibility fix |
| 1.6.37 | 1.16 | 11 | Single MP3 upload and queue busy enforcement |
| 1.6.36 | 1.15 | 11 | Final access-control cleanup |
| 1.6.35 | 1.15 | 11 | Password system removed |
| 1.6.34 | 1.14 | 11 | Last password-protected release |

Core, API, web assets, and OpenAPI schema should be installed from the same release.

### GUI consistency update

- Standardized card heading dividers across all modules.
- Replaced inactive `Quiet` labels with `None`.
- Corrected Lighting page spacing and the Web password double divider.
