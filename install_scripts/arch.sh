#!/usr/bin/env bash

# Install favorite packages
sudo pacman -Ssy
sudo pacman -S --noconfirm --needed grub \
efibootmgr \
xorg \
xfce4 \
xfce4-goodies \
vlc \
firefox \
lightdm \
lightdm-gtk-greeter \
sudo \
git \
openssh \
alsa-utils \
pulseaudio \
peek \
pavucontrol \
shellcheck \
zsh \
xsel \
xclip \
neovim \
python-pip \
nodejs \
npm \
fd \
podman \
virt-manager \
libvirt \
qemu \
htop \
go \
meld \
lynis \
tree \
curl \
trash-cli \
thermald \
neofetch \
unzip \
rust \
wget \
reflector \
bluez \
blueman \
bluez-utils \
pulseaudio-bluetooth \
gvfs \
ntfs-3g

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
