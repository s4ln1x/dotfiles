#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install \
    apt-listbugs \
    apt-listchanges \
    bat \
    build-essential \
    curl \
    dconf-editor \
    debootstrap \
    devscripts \
    eza \
    fastfetch \
    fd-find \
    fzf \
    git \
    golang \
    htop \
    libvirt-clients \
    libvirt-daemon-system \
    lynis \
    meld \
    mpd \
    neovim \
    pavucontrol \
    peek \
    podman \
    python3-pip \
    qemu-system \
    ripgrep \
    shellcheck \
    sway \
    thermald \
    tmux \
    trash-cli \
    tree \
    vim-airline \
    vim-gitgutter \
    virt-manager \
    waybar \
    xclip \
    xsel \
    zoxide \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# Note: Debian packages bat as 'batcat' and fd as 'fdfind' due to name conflicts.
# If you want normal names, add these symlinks:
mkdir -p "${HOME}/.local/bin"
[[ -x /usr/bin/batcat ]] && ln -sf /usr/bin/batcat "${HOME}/.local/bin/bat"
[[ -x /usr/bin/fdfind ]] && ln -sf /usr/bin/fdfind "${HOME}/.local/bin/fd"
