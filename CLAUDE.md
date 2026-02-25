# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

Personal dotfiles for macOS and Fedora/RHEL. There are no build, test, or lint commands — this repo is deployed by running scripts.

## Deployment

**Step 1 — Bootstrap a new machine** (run once):
```bash
./setup/setup-macos.sh   # macOS: installs everything via Homebrew
./setup/setup.sh         # Fedora/RHEL: installs via DNF + Flatpak
```

**Step 2 — Symlink configs** (run after cloning):
```bash
./install.sh
```
This symlinks `.zshrc`, `nvim/`, and `kitty/` into `~/.config/` and `~/`. If `.p10k.zsh` is not in the repo, run `p10k configure` after linking and then commit the result.

**One-off fixes:**
```bash
./setup/fix-cedilla   # Linux X11 only: fixes 'c → ç for Brazilian/Portuguese keyboards
```

## Architecture

### Shell (`.zshrc`)
- **Plugin manager:** Zinit with deferred loading (`zinit wait lucid`) for non-critical plugins (syntax highlighting, autosuggestions, fzf-tab)
- **Prompt:** Powerlevel10k with instant-prompt enabled; config lives in `~/.p10k.zsh` (not tracked unless committed)
- **OS detection:** `$OSTYPE` → `$OS` variable used throughout to branch macOS vs Linux behaviour (Homebrew PATH, `ls` colour flags, fzf-tab previews)
- **Shell integrations:** `fzf --zsh` and `zoxide init` evaluated at the bottom of `.zshrc`

### Neovim (`nvim/`)
- **Framework:** LazyVim — `init.lua` only bootstraps `config.lazy`
- **Custom config:** `nvim/lua/config/` (autocmds, keymaps, options, lazy bootstrap)
- **Plugin overrides:** `nvim/lua/plugins/` — each file adds, disables, or configures LazyVim plugins. `disabled.lua` turns off unwanted LazyVim defaults
- **Plugin lock file:** `lazy-lock.json` pins plugin versions; update with `:Lazy update` inside Neovim

### Kitty (`kitty/`)
- `kitty.conf` — main config
- `current-theme.conf` — sourced by `kitty.conf`; swap themes by replacing this file (Tokyo Night by default)

### Setup scripts (`setup/`)
- `setup-macos.sh` — Homebrew only; VS Code install is commented out intentionally
- `setup.sh` — DNF + Flatpak + curl-installed Kitty; prompts interactively for editor choices (Antigravity, Cursor, VS Code) at the top before running
- `fix-cedilla` — modifies `~/.XCompose` by transforming the system compose file; log out to apply
