#!/usr/bin/env bash
set -euo pipefail

# Refresh package databases. `-Syy` forces a full refresh even if the DBs
# look up-to-date. (The old `-Ssy` was a no-op that searched for a package
# literally named "y".)
sudo pacman -Syy

# Install favorite packages
sudo pacman -S --noconfirm --needed \
    alsa-utils \
    bat \
    blueman \
    bluez \
    bluez-utils \
    curl \
    efibootmgr \
    eza \
    fastfetch \
    fd \
    firefox \
    fzf \
    git \
    go \
    grub \
    gvfs \
    htop \
    libvirt \
    lightdm \
    lightdm-gtk-greeter \
    lynis \
    meld \
    neovim \
    ntfs-3g \
    openssh \
    pavucontrol \
    peek \
    podman \
    pulseaudio \
    pulseaudio-bluetooth \
    python-pip \
    qemu \
    reflector \
    ripgrep \
    rust \
    shellcheck \
    sudo \
    thermald \
    tmux \
    trash-cli \
    tree \
    unzip \
    virt-manager \
    vlc \
    wget \
    xclip \
    xfce4 \
    xfce4-goodies \
    xorg \
    xsel \
    zoxide \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting \
    zsh-theme-powerlevel10k

# Enable bluetooth
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# Add current user to the wheel group for sudo access
sudo usermod -aG wheel "${USER}"

echo '
     polkit.addRule(function(action, subject) {
         if ((action.id == "org.blueman.rfkill.setstate" ||
              action.id == "org.blueman.network.setup") &&
              subject.local && subject.active && subject.isInGroup("wheel")) {

             return polkit.Result.YES;
         }
     });
     ' | sudo tee /etc/polkit-1/rules.d/81-blueman.rules > /dev/null
