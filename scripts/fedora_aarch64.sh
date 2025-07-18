#!/usr/bin/env bash

# Install rpmfusion mirrors
sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

sudo dnf install -y \
@development-tools \
@virtualization \
ShellCheck \
akmod-nvidia \
cargo \
cockpit \
cockpit-machines \
cockpit-podman \
cockpit-session-recording \
crontabs \
dconf-editor \
fd-find \
fedora-packager \
fedora-review \
fira-code-fonts \
firefox \
gcc-c++ \
gimp \
gnome-extensions-app \
gnome-shell-extension-appindicator \
gnome-shell-extension-pomodoro \
gnome-tweaks \
golang \
htop \
inotify-tools \
jetbrains-mono-fonts-all \
libvirt \
lynis \
meld \
nodejs \
npm \
nvidia-gpu-firmware \
openssh \
peek \
powerline-fonts \
rpmconf \
rust \
srace \
telegram-desktop \
tmux \
trash-cli \
util-linux-user \
vgrep \
vim \
virt-manager \
wimlib-utils \
wordnet \
xclip \
xorg-x11-drv-nvidia-cuda \
xsel \
zsh

# Enable video
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
sudo dnf install -y \
    gstreamer1-plugins-{base,good,bad-free,ugly} \
    gstreamer1-plugin-openh264 \
    libavcodec-freeworld \
    vlc \
    mpv
