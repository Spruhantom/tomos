# One-line Omarchy installer

The installer script at `bin/install-omarchy` installs the Arch dependencies, clones or updates this repository under `~/.local/share/tomphone`, builds Tomphone, and installs a per-user launcher.

Run from a terminal:

```bash
curl -fsSL https://raw.githubusercontent.com/Spruhantom/tomos/main/bin/install-omarchy | bash
```

This repository is currently private. The raw URL is accessible only to users with appropriate GitHub authentication, and anonymous `curl` will not work unless the repository is made public. For a private repository, clone with your configured Git credentials first and run `./bin/install-omarchy`.

This script installs the **Linux/Omarchy x86_64 desktop app**, not an Android APK. The Android/PJSIP port is not present in this repository's main branch.
