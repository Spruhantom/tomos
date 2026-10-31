# Tomphone

Tomphone is a compact Linux desktop softphone for registering a SIP account and making or receiving audio calls. Its updated dialer puts the number pad, call controls, and connection status in one focused window, with an account panel for setup. Colors, accent, light or dark mode, text selection, and corner radius follow the active desktop theme where supported.

## One-line install (Arch Linux / Omarchy)

Run this command in a terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/Spruhantom/tomos/main/bin/install-arch | bash
```

This installer targets x86-64 Arch Linux and Arch-based distributions. It installs the build dependencies with pacman, clones or updates the source, builds Tomphone, and installs a per-user launcher and icon. It uses sudo for package installation.

Launch with:

```bash
tomphone
```

If `tomphone` is not on your PATH, use `~/.local/bin/tomphone`.

## Manual build

Run `bin/build` to compile. The Arch package files are in `pkgbuild/`.

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
