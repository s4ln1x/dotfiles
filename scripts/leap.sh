#!/usr/bin/env bash
set -euo pipefail

# Enabling multimedia
sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman
sudo zypper refresh
sudo zypper dist-upgrade --from packman --allow-vendor-change
sudo zypper install --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs

# Install favorite packages
sudo zypper -n update
sudo zypper -n install \
    ShellCheck \
    bat \
    devscripts \
    fakeroot \
    fastfetch \
    fd \
    fd-zsh-completion \
    fuse-exfat \
    fzf \
    git \
    gnome-pomodoro \
    go \
    htop \
    libvirt \
    lynis \
    meld \
    neovim \
    peek \
    podman \
    python3-pip \
    ripgrep \
    tmux \
    vgrep \
    vim \
    virt-manager \
    xclip \
    xsel \
    zoxide \
    zsh \
    zsh-syntax-highlighting

# Note: zsh-autosuggestions and powerlevel10k may not be in the main openSUSE
# repos. Check with `zypper search` and install via OBS if needed, or the
# .zshrc will skip them gracefully.
