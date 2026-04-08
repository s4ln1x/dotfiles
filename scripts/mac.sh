#!/usr/bin/env bash
set -euo pipefail

# Install Homebrew if missing
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# CLI tools
brew install \
    bat \
    eza \
    fastfetch \
    fd \
    fzf \
    git \
    htop \
    podman \
    powerlevel10k \
    ripgrep \
    tmux \
    tree \
    vim \
    zoxide \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# Fonts
brew install --cask font-meslo-lg-nerd-font
