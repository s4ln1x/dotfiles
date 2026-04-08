#!/usr/bin/env bash
set -euo pipefail

# Install favorite packages
sudo pacman -Ssy
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
sudo usermod -aG wheel "${USER}"
sudo gpasswd -a "${USER}" wheel

echo '
     polkit.addRule(function(action, subject) {
         if ((action.id == "org.blueman.rfkill.setstate" ||
              action.id == "org.blueman.network.setup") &&
              subject.local && subject.active && subject.isInGroup("wheel")) {

             return polkit.Result.YES;
         }
     });
     ' | sudo tee /etc/polkit-1/rules.d/81-blueman.rules > /dev/null
