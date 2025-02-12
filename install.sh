#!/bin/bash

REPO_URL="https://raw.githubusercontent.com/koderstory/linux-kickstarter/v0.1.0"
INSTALL_DIR="$HOME/.linux-kickstarter"
ESSENTIAL_PACKAGES=(
    "curl"
    "git"
    "gpg"
    "htop"
    "openssh-client" # ssh-keygen command
    "wget"
    "whiptail"
)

set -e  # Enable exit on error

# ===================================================================================
# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install essential packages
sudo apt-get install -y "${ESSENTIAL_PACKAGES[@]}"

echo "🔧 Install Linux Kickstarter to $INSTALL_DIR..."

mkdir -p "$INSTALL_DIR/modules"

# Download scripts
curl -sS -o "$INSTALL_DIR/kickstarter.sh" "$REPO_URL/kickstarter.sh"
curl -sS -o "$INSTALL_DIR/modules/packages.sh" "$REPO_URL/modules/packages.sh"
curl -sS -o "$INSTALL_DIR/modules/messages.sh" "$REPO_URL/modules/messages.sh"
curl -sS -o "$INSTALL_DIR/modules/prompt.sh" "$REPO_URL/modules/prompt.sh"
curl -sS -o "$INSTALL_DIR/modules/systems.sh" "$REPO_URL/modules/systems.sh"

# Tambahkan ke shell profile
SHELL_RC="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q 'kickstarter.sh' "$SHELL_RC"; then
    echo "source $INSTALL_DIR/kickstarter.sh" >> "$SHELL_RC"
fi

echo "✅ Instalasi selesai! Silakan restart terminal atau jalankan:"
echo "   source $SHELL_RC"