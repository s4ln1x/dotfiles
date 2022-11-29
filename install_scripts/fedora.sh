#!/usr/bin/env bash

sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm

sudo dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

sudo dnf install -y @Multimedia \
@virtualization \
@development-tools \
dconf-editor \
gnome-tweaks \
peek \
ShellCheck \
fd-find \
trash-cli \
thermald \
nodejs \
npm \
zsh \
xclip \
xsel \
neofetch \
util-linux-user \
virt-manager \
libvirt \
htop \
vgrep \
gnome-shell-extension-pomodoro \
golang \
lynis \
meld \
telegram-desktop \
cockpit \
cockpit-machines \
cockpit-podman \
cockpit-session-recording \
crontabs \
rpmconf \
gnome-extensions-app \
gnome-shell-extension-appindicator \
vim \
steam \
rust \
cargo \
fedora-packager \
fedora-review \
inotify-tools
