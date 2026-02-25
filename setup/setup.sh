#!/bin/bash

# ── WSL detection ──────────────────────────────────────────────────────────────
is_wsl=false
if grep -qi microsoft /proc/version 2>/dev/null; then
  is_wsl=true
fi
# ──────────────────────────────────────────────────────────────────────────────

# ── Dependencies ──────────────────────────────────────────────────────────────
if ! command -v whiptail &>/dev/null; then
  sudo dnf install -y newt
fi
# ──────────────────────────────────────────────────────────────────────────────

# ── Program selection ──────────────────────────────────────────────────────────
kitty_default=$($is_wsl && echo "OFF" || echo "ON")

choices=$(whiptail --title "Fedora Setup" \
  --checklist "Select programs to install:" 23 70 15 \
  "chrome"      "Google Chrome"                                     ON  \
  "filezilla"   "FileZilla"                                         ON  \
  "obsidian"    "Obsidian"                                          ON  \
  "dbeaver"     "DBeaver"                                           ON  \
  "obs"         "OBS Studio"                                        ON  \
  "telegram"    "Telegram"                                          ON  \
  "discord"     "Discord"                                           ON  \
  "whatsie"     "Whatsie"                                           ON  \
  "gnome-ext"   "GNOME Extensions"                                  ON  \
  "spotify"     "Spotify"                                           ON  \
  "kitty"       "Kitty terminal"                       "$kitty_default" \
  "nerd-fonts"  "Nerd Fonts (Meslo, FiraCode, FiraMono, JetBrainsMono)" ON \
  "antigravity" "Antigravity"                                       OFF \
  "cursor"      "Cursor"                                            OFF \
  "vscode"      "Visual Studio Code"                                OFF \
  3>&1 1>&2 2>&3)

[[ $? -ne 0 ]] && { echo "Cancelled."; exit 1; }

selected() { echo "$choices" | grep -q "\"$1\""; }
# ──────────────────────────────────────────────────────────────────────────────

# ── DNF packages ───────────────────────────────────────────────────────────────
dnf_packages=(zsh neovim python3-neovim)

if selected chrome; then
  sudo dnf config-manager --set-enabled google-chrome
  dnf_packages+=(google-chrome-stable)
fi
selected filezilla && dnf_packages+=(filezilla)

sudo dnf install -y "${dnf_packages[@]}"
# ──────────────────────────────────────────────────────────────────────────────

# ── Flatpak apps ───────────────────────────────────────────────────────────────
flatpak_apps=()
selected obsidian  && flatpak_apps+=(md.obsidian.Obsidian)
selected dbeaver   && flatpak_apps+=(io.dbeaver.DBeaverCommunity)
selected obs       && flatpak_apps+=(com.obsproject.Studio)
selected telegram  && flatpak_apps+=(org.telegram.desktop)
selected discord   && flatpak_apps+=(com.discordapp.Discord)
selected whatsie   && flatpak_apps+=(com.ktechpit.whatsie)
selected gnome-ext && flatpak_apps+=(org.gnome.Extensions)
selected spotify   && flatpak_apps+=(com.spotify.Client)

if [[ ${#flatpak_apps[@]} -gt 0 ]]; then
  flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  flatpak install flathub "${flatpak_apps[@]}"
fi
# ──────────────────────────────────────────────────────────────────────────────

# ── Kitty ──────────────────────────────────────────────────────────────────────
if selected kitty; then
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

  mkdir -p ~/.local/bin
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/
  ln -sf ~/.local/kitty.app/bin/kitten ~/.local/bin/

  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
  sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
  sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
  echo 'kitty.desktop' >~/.config/xdg-terminals.list
fi
# ──────────────────────────────────────────────────────────────────────────────

# ── Nerd Fonts ─────────────────────────────────────────────────────────────────
if selected nerd-fonts; then
  fonts=("Meslo" "FiraCode" "FiraMono" "JetBrainsMono")
  fontpath="$HOME/.local/share/fonts"
  version="3.4.0"

  mkdir -p "$fontpath"
  for font in "${fonts[@]}"; do
    wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/download/v"$version"/"$font".zip -P /tmp
    unzip -q /tmp/"$font".zip -d "$fontpath"
    rm "$fontpath"/*Windows*
    rm /tmp/"$font".zip
  done

  fc-cache -fv
fi
# ──────────────────────────────────────────────────────────────────────────────

# ── Visual Studio Code ─────────────────────────────────────────────────────────
if selected vscode; then
  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
  sudo dnf check-update
  sudo dnf install -y code
fi
# ──────────────────────────────────────────────────────────────────────────────

# ── Cursor ─────────────────────────────────────────────────────────────────────
if selected cursor; then
  curl -L "https://api2.cursor.sh/updates/download/golden/linux-x64-rpm/cursor/2.5" -o /tmp/cursor.rpm
  sudo dnf install -y /tmp/cursor.rpm
  rm /tmp/cursor.rpm
fi
# ──────────────────────────────────────────────────────────────────────────────

# ── Antigravity ────────────────────────────────────────────────────────────────
if selected antigravity; then
  sudo tee /etc/yum.repos.d/antigravity.repo <<'EOF'
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOF
  sudo dnf install -y antigravity
fi
# ──────────────────────────────────────────────────────────────────────────────
