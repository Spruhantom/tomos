# Tomphone

Tomphone is a compact Omarchy desktop softphone for registering a SIP account and making or receiving audio calls. Its updated dialer puts the number pad, call controls, and connection status in one focused window, with an account panel for setup. Colors, accent, light or dark mode, text selection, and corner radius follow the active Omarchy theme.

## Build and install

Run `bin/build` to compile. Run `bin/install` to build and install the Arch package. The launcher entry is **Tomphone**.

On first launch, enter your SIP server, username, and password. Use the dial pad or enter a number or full SIP address. Space starts a call or hangs up; Q quits.

## Requirements

Qt 6, Baresip with its PulseAudio audio module, and a working PulseAudio-compatible audio service (PipeWire works).

## Shortcuts

| Key | Action |
|---|---|
| Space | Call or hang up |
| Q | Quit |

## Privacy

Account credentials are saved with owner-only file permissions under `~/.config/tomphone/account.json`. Baresip's TCP control channel listens only on `127.0.0.1`.
