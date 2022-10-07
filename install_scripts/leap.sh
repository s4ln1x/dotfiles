#!/usr/bin/env bash

# Enabling multimedia
sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/' packman
sudo zypper refresh
sudo zypper dist-upgrade --from packman --allow-vendor-change
sudo zypper install --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs

# Install favorite packages
sudo zypper -n update
sudo zypper -n install fakeroot \
peek \
ShellCheck \
zsh \
xsel \
xclip \
neofetch \
neovim \
python3-pip \
nodejs14 \
npm14 \
fd \
fd-zsh-completion \
fuse-exfat \
podman \
virt-manager \
libvirt \
htop \
vgrep \
go \
devscripts \
meld \
lynis \
gnome-pomodoro
