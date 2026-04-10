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
# Common packages (both architectures, any GPU)
# =============================================================================
sudo dnf install -y \
    @development-tools \
    @virtualization \
    ShellCheck \
    fastfetch \
    fd-find \
    fedora-packager \
    fedora-review \
    fzf \
    gcc-c++ \
    gimp \
    git \
    htop \
    jetbrains-mono-fonts-all \
    meld \
    podman \
    powerline-fonts \
    ripgrep \
    rpmconf \
    strace \
    telegram-desktop \
    tmux \
    trash-cli \
    util-linux-user \
    vim \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting

# =============================================================================
# NVIDIA stack — only if an NVIDIA GPU is actually present
# =============================================================================
# Installing akmod-nvidia on a non-NVIDIA machine pulls in kernel modules that
# try to build against an absent GPU and can wedge graphics. Detect first.
if command -v lspci &>/dev/null && lspci | grep -qi 'VGA.*NVIDIA\|3D.*NVIDIA'; then
  echo "NVIDIA GPU detected — installing proprietary driver stack"
  sudo dnf install -y \
      akmod-nvidia \
      nvidia-gpu-firmware \
      xorg-x11-drv-nvidia-cuda
else
  echo "No NVIDIA GPU detected — skipping akmod-nvidia and friends"
fi

# =============================================================================
# Architecture-specific packages
# =============================================================================
if [[ "$ARCH" == "x86_64" ]]; then
  sudo dnf install -y \
      @Multimedia \
      steam \
      thermald

elif [[ "$ARCH" == "aarch64" ]]; then
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
