# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Detect OS
case "$OSTYPE" in
  darwin*) OS="macos" ;;
  linux*)  OS="linux" ;;
  *)       OS="unknown" ;;
esac

# Homebrew (macOS - Apple Silicon or Intel)
if [[ "$OS" == "macos" ]]; then
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Ensure ~/.local/bin is in PATH (needed on Linux for kitty, etc.)
if [[ "$OS" == "linux" ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# zsh-completions must load before compinit
zinit light zsh-users/zsh-completions

# Load completions (with 24h cache to speed up startup)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zinit cdreplay -q

# Defer non-critical plugins until after prompt appears
zinit wait lucid light zsh-users/zsh-syntax-highlighting
zinit wait lucid light zsh-users/zsh-autosuggestions
zinit wait lucid light Aloxaf/fzf-tab

# Add in snippets
zinit wait lucid snippet OMZP::git
zinit wait lucid snippet OMZP::sudo
zinit wait lucid snippet OMZP::command-not-found

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
if [[ "$OS" == "macos" ]]; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -G $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -G $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
  zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
fi

# Environment
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias vim='nvim'
alias c='clear'
alias neofetch='fastfetch'

if [[ "$OS" == "macos" ]]; then
  alias ls='ls -G'
  alias la='ls -Ga'
  alias ll='ls -Gl'
  alias lla='ls -Gla'
else
  alias ls='ls --color'
  alias la='ls -a --color'
  alias ll='ls -l --color'
  alias lla='ls -la --color'
fi

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
