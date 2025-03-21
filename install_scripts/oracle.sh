#!/usr/bin/env bash

# Update the system
sudo dnf update -y

# Install desire applications
sudo dnf install -y golang \
    google-noto-sans-fonts \
    nodejs \
    npm \
    python3-pip \
    util-linux-user \
    zsh
