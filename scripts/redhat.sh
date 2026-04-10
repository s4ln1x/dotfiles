#!/usr/bin/env bash
set -euo pipefail

# Install third party repositories EPEL and RPMFusion
sudo subscription-manager repos --enable "codeready-builder-for-rhel-9-$(uname -m)-rpms"
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-"$(rpm -E %rhel)".noarch.rpm
sudo dnf install -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-"$(rpm -E %rhel)".noarch.rpm
sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-"$(rpm -E %rhel)".noarch.rpm

# Update system
sudo dnf group upgrade -y core
sudo dnf group upgrade -y multimedia --setop="install_weak_deps=False"
sudo dnf group upgrade -y sound-and-video

# Install desired applications
sudo dnf install -y \
    @Multimedia \
    fastfetch \
    fd-find \
    fzf \
    git \
    htop \
    podman \
    python3-pip \
    ripgrep \
    rpmconf \
    simple-scan \
    tmux \
    util-linux-user \
    vim-enhanced \
    vlc \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# Note: powerlevel10k is not packaged for RHEL. The .zshrc will skip it
# gracefully. If you want the theme, clone it manually:
#   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
#     "${HOME}/.local/share/powerlevel10k"
