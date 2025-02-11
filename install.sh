#!/bin/bash

REPO_URL="https://raw.githubusercontent.com/username/linux-kickstarter/main"
INSTALL_DIR="$HOME/.linux-kickstarter"
ESSENTIAL_PACKAGES=(
    "curl"
    "git"
    "gpg"
    "htop"
    "openssh-client" # ssh-keygen command
    "wget"
)

set -e  # Enable exit on error

# ===================================================================================
# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install essential packages
sudo apt-get install -y "${ESSENTIAL_PACKAGES[@]}"

# echo "🔧 Menginstal Linux Kickstarter ke $INSTALL_DIR..."

# Buat direktori
# mkdir -p "$INSTALL_DIR/modules"

# Unduh skrip utama
# curl -sS "$REPO_URL/kickstarter.sh" -o "$INSTALL_DIR/kickstarter.sh"

# Unduh modul-modul
# curl -sS "$REPO_URL/modules/base.sh" -o "$INSTALL_DIR/modules/base.sh"
# curl -sS "$REPO_URL/modules/media.sh" -o "$INSTALL_DIR/modules/media.sh"
# curl -sS "$REPO_URL/modules/dev.sh" -o "$INSTALL_DIR/modules/dev.sh"