#!/usr/bin/env bash

# Install rpmfusion mirrors
sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

sudo dnf install -y \
@Multimedia \
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
neofetch \
nodejs \
npm \
nvidia-gpu-firmware \
openssh \
peek \
powerline-fonts \
rpmconf \
rust \
steam \
telegram-desktop \
thermald \
tmux \
trash-cli \
util-linux-user \
vgrep \
vim \
virt-manager \
wordnet \
xclip \
xorg-x11-drv-nvidia-cuda \
xsel \
zsh
