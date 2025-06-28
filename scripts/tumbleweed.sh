#!/usr/bin/env bash

# Enabling multimedia
sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
sudo zypper refresh
sudo zypper dist-upgrade --from packman --allow-vendor-change
sudo zypper install --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs

# Install favorite packages
sudo zypper -n dist-upgrade
sudo zypper -n install fakeroot \
peek \
ShellCheck \
thermald \
xsel \
xclip \
neofetch \
neovim \
python3-pip \
nodejs15 \
npm15 \
fd \
fuse-exfat \
podman \
virt-manager \
libvirt \
blueberry \
tumbleweed-cli \
htop \
vgrep \
gnome-pomodoro \
go \
lynis \
meld \
zsh
