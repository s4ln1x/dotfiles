#!/usr/bin/env bash
set -euo pipefail

ARCH=$(uname -m)

# =============================================================================
# Third-party repos
# =============================================================================
sudo dnf install -y \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm

# =============================================================================
# Common packages (both architectures)
# =============================================================================
sudo dnf install -y \
    @development-tools \
    @virtualization \
    ShellCheck \
    akmod-nvidia \
    bat \
    cargo \
    cockpit \
    cockpit-machines \
    cockpit-podman \
    cockpit-session-recording \
    crontabs \
    dconf-editor \
    eza \
    fastfetch \
    fd-find \
    fedora-packager \
    fedora-review \
    fira-code-fonts \
    firefox \
    fzf \
    gcc-c++ \
    gimp \
    git \
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
    nvidia-gpu-firmware \
    openssh \
    peek \
    podman \
    powerline-fonts \
    ripgrep \
    rpmconf \
    rust \
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
    zoxide \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# =============================================================================
# Architecture-specific packages
# =============================================================================
if [[ "$ARCH" == "x86_64" ]]; then
  sudo dnf install -y \
      @Multimedia \
      steam \
      thermald

elif [[ "$ARCH" == "aarch64" ]]; then
  sudo dnf install -y \
      @x86-emulation \
      fex-emu \
      fex-emu-rootfs-fedora \
      muvm \
      strace

  # Enable video on aarch64 (x86_64 gets this from @Multimedia)
  sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
  sudo dnf install -y \
      gstreamer1-plugins-{base,good,bad-free,ugly} \
      gstreamer1-plugin-openh264 \
      libavcodec-freeworld \
      vlc \
      mpv

else
  echo "WARNING: Unknown architecture '$ARCH', skipping arch-specific packages"
fi
