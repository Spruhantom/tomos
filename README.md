# Tomphone

Tomphone is a compact Omarchy desktop softphone for registering a SIP account and making or receiving audio calls. It uses Baresip for SIP and audio, with its control interface bound to localhost. Its window colors, accent, light or dark mode, text selection, and corner radius follow the active Omarchy theme.

## Build and install

Run `bin/build` to compile. Run `bin/install` to build and install the Arch package. The launcher entry is **Tomphone**.

On first launch, enter your SIP server, username, and password. Calls can use a number or full SIP address. Space starts a call or hangs up; Q quits.

## Requirements

Qt 6, Baresip with its PulseAudio audio module, and a working PulseAudio-compatible audio service (PipeWire works).

## Shortcuts

| Key | Action |
|---|---|
| Space | Call or hang up |
| Q | Quit |

## Privacy

Account credentials are saved with owner-only file permissions under `~/.config/tomphone/account.json`. Baresip's TCP control channel listens only on `127.0.0.1`.
