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

Run the install script after cloning:

```bash
./install.sh
```

This symlinks `.zshrc`, `nvim/`, and `kitty/` into the correct locations. If `.p10k.zsh` is present in the repo it will be linked too — otherwise run `p10k configure` to generate it, then commit the result.
