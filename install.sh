#!/bin/bash

REPO_URL="https://raw.githubusercontent.com/koderstory/linux-kickstarter/v0.1.3"
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
echo "🔄 Updating system..."
sudo apt-get update
sudo apt-get upgrade -y

# Install essential packages
echo "📦 Installing essential packages..."
sudo apt-get install -y "${ESSENTIAL_PACKAGES[@]}"

echo "🔧 Installing Linux Kickstarter to $INSTALL_DIR..."

# Create installation directory
mkdir -p "$INSTALL_DIR/modules"

# Download scripts
echo "📥 Downloading scripts..."
curl -sS -o "$INSTALL_DIR/kickstart.sh" "$REPO_URL/kickstart.sh" || {
    echo "❌ Failed to download kickstart.sh"
    exit 1
}
curl -sS -o "$INSTALL_DIR/modules/packages.sh" "$REPO_URL/modules/packages.sh" || {
    echo "❌ Failed to download packages.sh"
    exit 1
}
curl -sS -o "$INSTALL_DIR/modules/messages.sh" "$REPO_URL/modules/messages.sh" || {
    echo "❌ Failed to download messages.sh"
    exit 1
}
curl -sS -o "$INSTALL_DIR/modules/prompt.sh" "$REPO_URL/modules/prompt.sh" || {
    echo "❌ Failed to download prompt.sh"
    exit 1
}
curl -sS -o "$INSTALL_DIR/modules/systems.sh" "$REPO_URL/modules/systems.sh" || {
    echo "❌ Failed to download systems.sh"
    exit 1
}

# Add to shell profile
SHELL_RC="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q 'kickstarter.sh' "$SHELL_RC"; then
    echo "🔗 Adding Linux Kickstarter to $SHELL_RC..."
    echo "source $INSTALL_DIR/kickstarter.sh" >> "$SHELL_RC"
fi

echo "✅ Installation complete! Please restart your terminal or run:"
echo "   source $SHELL_RC"