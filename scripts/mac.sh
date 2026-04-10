#!/usr/bin/env bash
set -euo pipefail

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# CLI tools
brew install \
    fastfetch \
    fd \
    fzf \
    powerlevel10k \
    ripgrep \
    tmux \
    tree \
    vim \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# Fonts
brew install --cask font-meslo-lg-nerd-font
