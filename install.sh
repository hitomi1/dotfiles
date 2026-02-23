#!/bin/bash

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$DOTFILES/$1"
  local dst="${2:-$HOME/$1}"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "linked $dst"
}

link .zshrc
link nvim   "$HOME/.config/nvim"
link kitty  "$HOME/.config/kitty"

# Link .p10k.zsh if present in dotfiles
if [[ -f "$DOTFILES/.p10k.zsh" ]]; then
  link .p10k.zsh
fi

echo "Done. Restart your shell or run: source ~/.zshrc"
