# Setup Scripts

Scripts for bootstrapping a new machine.

## `setup-macos.sh` — macOS

Installs everything via [Homebrew](https://brew.sh).

```bash
./setup/setup-macos.sh
```

**Installs:**
- CLI tools: zsh, neovim, fzf, zoxide, fastfetch, wget, python3
- GUI apps: Kitty, Obsidian, DBeaver, OBS, Telegram, Discord, Spotify, VS Code
- Nerd Fonts: Meslo LG, Fira Code, Fira Mono

Homebrew itself is installed automatically if not already present.

---

## `setup.sh` — Fedora / RHEL

Installs packages via DNF and Flatpak.

```bash
./setup/setup.sh
```

**Installs:**
- DNF packages: zsh, neovim, python3-neovim, google-chrome, filezilla
- Flatpak apps: Obsidian, DBeaver, OBS, Telegram, Discord, Whatsie, GNOME Extensions, Spotify
- Kitty terminal (via curl installer + symlinks)
- Nerd Fonts: Meslo, Fira Code, Fira Mono (v3.2.1)
- Visual Studio Code (via Microsoft RPM repo)

---

## `fix-cedilla` — Linux (X11)

Fixes the cedilla (`ç`) key on Brazilian/Portuguese keyboard layouts under X11/GNOME, where `'c` would incorrectly produce `ć` instead of `ç`.

```bash
./setup/fix-cedilla
```

Creates `~/.XCompose` with the corrected key mapping. Log out and back in to apply. To revert, delete `~/.XCompose`.
