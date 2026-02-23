# dotfiles

Personal dotfiles for macOS and Fedora.

## Contents

| Path | Description |
|------|-------------|
| `.zshrc` | Zsh config — Zinit, Powerlevel10k, fzf, zoxide |
| `nvim/` | Neovim config via [LazyVim](https://www.lazyvim.org) |
| `kitty/` | Kitty terminal config with Tokyo Night theme |
| `setup/` | Bootstrap scripts for macOS and Fedora |

## Setup

**macOS:**
```bash
./setup/setup-macos.sh
```

**Fedora:**
```bash
./setup/setup.sh
```

See [`setup/README.md`](setup/README.md) for details.

## Symlinks

Link the configs into place after cloning:

```bash
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/kitty ~/.config/kitty
```
