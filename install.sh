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
)

set -e  # Enable exit on error

# ===================================================================================
# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install essential packages
sudo apt-get install -y "${ESSENTIAL_PACKAGES[@]}"

echo "🔧 Install Linux Kickstarter to $INSTALL_DIR..."

# mkdir -p "$INSTALL_DIR/configs"
# mkdir -p "$INSTALL_DIR/helpers"
# mkdir -p "$INSTALL_DIR/tasks"

# Download scripts
# curl -sS "$REPO_URL/kickstarter.sh" -o "$INSTALL_DIR/kickstarter.sh"
# curl -sS "$REPO_URL/configs/packages.sh" -o "$INSTALL_DIR/configs/packages.sh"
# curl -sS "$REPO_URL/helpers/messages.sh" -o "$INSTALL_DIR/helpers/messages.sh"
# curl -sS "$REPO_URL/helpers/prompt.sh" -o "$INSTALL_DIR/helpers/prompt.sh"
# curl -sS "$REPO_URL/helpers/systems.sh" -o "$INSTALL_DIR/helpers/systems.sh"

# Remove all downloaded files
rm -rf "$INSTALL_DIR/.linux-kickstarter" && exit