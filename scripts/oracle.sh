#!/usr/bin/env bash
set -euo pipefail

# Update the system
sudo dnf update -y

# Enable EPEL and CodeReady Builder (required for many dev tools)
sudo dnf install -y "oracle-epel-release-el$(rpm -E %rhel)"
sudo dnf config-manager --enable "ol$(rpm -E %rhel)_codeready_builder"

# Install desired applications
sudo dnf install -y \
    bat \
    fastfetch \
    fd-find \
    fzf \
    git \
    golang \
    google-noto-sans-fonts \
    htop \
    podman \
    python3-pip \
    ripgrep \
    tmux \
    util-linux-user \
    vim-enhanced \
    zoxide \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# Note: powerlevel10k is not packaged for Oracle Linux. The .zshrc will skip
# it gracefully. If you want the theme, clone it manually:
#   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
#     "${HOME}/.local/share/powerlevel10k"
