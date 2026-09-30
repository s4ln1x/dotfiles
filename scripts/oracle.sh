#!/usr/bin/env bash
set -euo pipefail

# Update the system
sudo dnf update -y

# Enable EPEL and CodeReady Builder (required for many dev tools)
sudo dnf install -y "oracle-epel-release-el$(rpm -E %rhel)"
sudo dnf config-manager --enable "ol$(rpm -E %rhel)_codeready_builder"

# Node.js 20 LTS — the newest stream verified in OL9 AppStream
sudo dnf module enable -y nodejs:20

# Install desired applications
sudo dnf install -y \
    fastfetch \
    fd-find \
    fzf \
    git \
    htop \
    nodejs \
    podman \
    python3-pip \
    ripgrep \
    tmux \
    util-linux-user \
    vim-enhanced \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting
