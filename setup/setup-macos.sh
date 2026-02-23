#!/bin/bash

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Add Homebrew to shell environment
echo >> "$HOME/.zprofile"
echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> "$HOME/.zprofile"
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# Install CLI tools
brew install \
  zsh \
  neovim \
  python3 \
  fzf \
  zoxide \
  fastfetch \
  wget

# Install GUI apps via Homebrew Cask
brew install --cask \
  kitty \
  obsidian \
  dbeaver-community \
  obs \
  telegram \
  discord \
  spotify \
  # visual-studio-code

# Install Nerd Fonts
brew install --cask \
  font-meslo-lg-nerd-font \
  font-fira-code-nerd-font \
  font-fira-mono-nerd-font
