#!/usr/bin/env bash

source ~/.zshrc_install

i3=1

case "${DISTRO}" in
    "ubuntu")
        sudo apt install -y i3
        ;;

    "leap")
        sudo zypper install -n i3-gaps \
        feh \
        blueberry \
        NetworkManager-applet \
        dunst \
        pavucontrol
        ;;
    "tumbleweed")
        sudo zypper install -n i3-gaps \
        feh \
        blueberry \
        NetworkManager-applet \
        dunst \
        pavucontrol
        ;;
    "fedora")
        sudo dnf install -y i3 \
        feh \
        blueberry \
	network-manager-applet \
        dunst \
        pavucontrol
        ;;
    "arch")
        sudo pacman -S --noconfirm --needed i3 \
        feh \
        blueberry \
        dunst \
        pavucontrol \
        dmenu
        ;;
    *)
        echo "No distro detected"
        i3=0
    ;;
esac

# Configuration
if [[ ${i3} -eq 1 ]]; then
    echo "Updating configuration"
    rm -rf "${HOME}"/.config/i3
    rm -rf "${HOME}"/.config/i3status
    ln -s "${HOME}"/repos/dotfiles/config/i3 "${HOME}"/.config/i3
    ln -s "${HOME}"/repos/dotfiles/config/i3status "${HOME}"/.config/i3status
fi
