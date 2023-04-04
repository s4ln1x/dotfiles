#!/usr/bin/env bash

# Install third party repositories EPEL, RPMFusion and Negativo17
sudo dnf install -y --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-"$(rpm -E %rhel)".noarch.rpm
sudo dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-"$(rpm -E %rhel)".noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-"$(rpm -E %rhel)".noarch.rpm
sudo subscription-manager repos --enable "codeready-builder-for-rhel-8-$(uname -m)-rpms"
sudo dnf config-manager --add-repo="https://negativo17.org/repos/epel-steam.repo"

# Update system
sudo dnf groupupdate -y core
sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
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
    htop \
    libvirt \
    nodejs \
    npm \
    rpmconf \
    simple-scan \
    steam \
    thermald \
    util-linux-user \
    virt-manager \
    vlc \
    zsh

# Add flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y com.todoist.Todoist \
    com.spotify.Client

sudo git clone https://github.com/paroj/xpad.git /usr/src/xpad-0.4 && cd /usr/src/xpad-0.4 || exit 1
sudo dkms install -m xpad -v 0.4