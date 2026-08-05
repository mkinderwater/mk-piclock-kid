# mk-piclock v1.9.17-rpi-zero-r3 Release Notes

This maintenance release removes an unused web GUI helper while retaining the Story Mode network-diagnostics fix from v1.9.16.

## Web module context cleanup

- Removed the unused `$$` wrapper around `host.querySelectorAll(...)` from `app.js`.
- Removed `$$` from the frozen context supplied to each GUI module.
- Verified that none of the 11 modules references `ctx.$$` or destructures a `$$` helper.
- Preserved direct, scoped `querySelectorAll(...)` calls used by modules that need multiple elements.
- No GUI behaviour or API contract changes.

## Network diagnostics touch fix retained

- An eight-second touch hold opens network diagnostics while a story or music is playing.
- A hold beginning during the Story Mode intro remains eligible for diagnostics.
- Playback continues behind the diagnostic screen.
- The completed hold is consumed, preventing another touch action on release.
- Active alarms retain priority.

## Compatibility

- Product version: `1.9.17-rpi-zero-r3`
- HTTP API version: `1.26`
- Private IPC version: `16`
- Target hardware: Raspberry Pi Zero W and Raspberry Pi Zero 2 W
