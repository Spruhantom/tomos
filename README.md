# Tomphone

Tomphone is a compact Omarchy desktop softphone for registering a SIP account and making or receiving audio calls. Its updated dialer puts the number pad, call controls, and connection status in one focused window, with an account panel for setup. Colors, accent, light or dark mode, text selection, and corner radius follow the active Omarchy theme.

## Build and install

### One-line install on Omarchy

Tomphone's GitHub repository is private, so authenticate with GitHub CLI first:

```bash
gh auth login
```

Then run this one-line installer:

```bash
curl -fsSL -H "Authorization: Bearer $(gh auth token)" -H "Accept: application/vnd.github.raw" https://api.github.com/repos/Spruhantom/tomos/contents/bin/install-omarchy | bash
```

The installer installs the required Arch packages, downloads or updates the source, builds Tomphone, and installs the app launcher and icon. It targets x86-64 Omarchy/Arch Linux.

Launch Tomphone with:

```bash
tomphone
```

If the command is not on your PATH, run `~/.local/bin/tomphone`.

### Manual install

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
