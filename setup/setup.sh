#!/bin/bash

# Enable Google Chrome repository
sudo dnf config-manager --set-enabled google-chrome

# Install packages via DNF
sudo dnf install -y zsh google-chrome-stable filezilla neovim python3-neovim

# Add Flathub repository if not exists
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install Flatpak applications
flatpak install flathub \
  md.obsidian.Obsidian \
  io.dbeaver.DBeaverCommunity \
  com.obsproject.Studio \
  org.telegram.desktop \
  com.discordapp.Discord \
  com.ktechpit.whatsie \
  org.gnome.Extensions \
  com.spotify.Client

# Install Kitty terminal emulator
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Create symbolic links for kitty and kitten
mkdir -p ~/.local/bin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/

# Update kitty.desktop files
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
echo 'kitty.desktop' >~/.config/xdg-terminals.list

# Install Nerd Fonts
fonts=("Meslo" "FiraCode" "FiraMono")
fontpath="$HOME/.local/share/fonts"
version="3.2.1"

for font in "${fonts[@]}"; do
  wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/download/v"$version"/"$font".zip -P /tmp
  unzip -q /tmp/"$font".zip -d "$fontpath"
  rm "$fontpath"/*Windows*
  rm /tmp/"$font".zip
done

fc-cache -fv

# Install Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
sudo dnf check-update
sudo dnf install code
