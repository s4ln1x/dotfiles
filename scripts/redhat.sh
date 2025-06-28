#!/usr/bin/env bash

# Install third party repositories EPEL and RPMFusion
sudo subscription-manager repos --enable "codeready-builder-for-rhel-9-$(uname -m)-rpms"
sudo dnf install -y --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-"$(rpm -E %rhel)".noarch.rpm
sudo dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-"$(rpm -E %rhel)".noarch.rpm
sudo dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-"$(rpm -E %rhel)".noarch.rpm

# Update system
sudo dnf groupupdate -y core
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False"
sudo dnf groupupdate -y sound-and-video

# Install desire applications
sudo dnf install -y @Multimedia \
    cockpit \
    cockpit-machines \
    cockpit-podman \
    cockpit-session-recording \
    dconf-editor \
    gnome-tweaks \
    golang \
    google-noto-sans-fonts \
    htop \
    libvirt \
    nodejs \
    npm \
    python3-pip \
    rpmconf \
    simple-scan \
    steam \
    thermald \
    util-linux-user \
    virt-manager \
    vlc \
    zsh
