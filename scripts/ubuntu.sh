#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update && sudo apt-get -y upgrade
sudo apt-get -y install \
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
    neovim \
    peek \
    podman \
    python3-pip \
    qemu-system \
    ripgrep \
    shellcheck \
    thermald \
    tmux \
    trash-cli \
    tree \
    vim-airline \
    vim-gitgutter \
    virt-manager \
    wordnet \
    xclip \
    xsel \
    zoxide \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# Ubuntu (like Debian) packages bat as 'batcat' and fd as 'fdfind'
mkdir -p "${HOME}/.local/bin"
[[ -x /usr/bin/batcat ]] && ln -sf /usr/bin/batcat "${HOME}/.local/bin/bat"
[[ -x /usr/bin/fdfind ]] && ln -sf /usr/bin/fdfind "${HOME}/.local/bin/fd"

# Note: eza, fastfetch, and zoxide require Ubuntu 24.04+. On older releases,
# either drop them from the list above or install via cargo/brew/manual.
