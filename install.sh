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
curl -sS -o "$REPO_URL/kickstarter.sh" "$INSTALL_DIR/kickstarter.sh" \
    -o "$REPO_URL/modules/packages.sh" "$INSTALL_DIR/modules/packages.sh" \
    -o "$REPO_URL/modules/messages.sh" "$INSTALL_DIR/modules/messages.sh" \
    -o "$REPO_URL/modules/prompt.sh" "$INSTALL_DIR/modulues/prompt.sh" \
    -o "$REPO_URL/modules/systems.sh" "$INSTALL_DIR/modules/systems.sh"
