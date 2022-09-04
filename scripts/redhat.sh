#!/usr/bin/env bash

sudo dnf install -y --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E %rhel).noarch.rpm
sudo dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm

sudo subscription-manager repos --enable "codeready-builder-for-rhel-8-$(uname -m)-rpms"

sudo dnf groupupdate -y core

sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

sudo dnf groupupdate -y sound-and-video

sudo dnf install -y @Multimedia \
dconf-editor \
gnome-tweaks \
thermald \
nodejs \
npm \
zsh \
util-linux-user \
virt-manager \
libvirt \
golang \
cockpit \
cockpit-machines \
cockpit-podman \
cockpit-session-recording \
vlc \
rpmconf \
htop
