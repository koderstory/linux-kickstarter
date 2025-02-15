#!/bin/bash

REPO_URL="https://raw.githubusercontent.com/koderstory/linux-kickstarter/v0.1.5"
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

set -e # Enable exit on error

# Fungsi spinner
spinner() {
    local pid=$1
    local msg=$2
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        for i in $(seq 0 9); do
            printf "\r\033[34m${spinstr:$i:1} ${msg}\033[0m"
            sleep $delay
        done
    done
    printf "\r\033[1;32m✓ Done\033[0m ${msg}\n"
}

sudo -v
if [ $? -eq 0 ]; then
    echo -e "\033[1;32m✓ Authenticated\033[0m\n"
else
    echo -e "\033[1;31m✗ Authentication failed\033[0m\n"
    exit 1
fi

# Update the system
echo "○ Update system"
(sudo apt-get update && sudo apt-get upgrade -y) > /dev/null 2>&1 &
spinner $! "Updating system..."

# Install essential packages
echo "○ Install essentials"
(sudo apt-get install -y "${ESSENTIAL_PACKAGES[@]}") > /dev/null 2>&1 &
spinner $! "Installing essential packages..."

# Create installation directory
mkdir -p "$INSTALL_DIR/modules"
echo "\n\033[1;32m✓ Done\033[0m Directory created\n"

# Download scripts
echo "○ Download scripts"
(
    curl -sS -o "$INSTALL_DIR/kickstart.sh" "$REPO_URL/kickstart.sh" &&
    curl -sS -o "$INSTALL_DIR/modules/packages.sh" "$REPO_URL/modules/packages.sh" &&
    curl -sS -o "$INSTALL_DIR/modules/messages.sh" "$REPO_URL/modules/messages.sh" &&
    curl -sS -o "$INSTALL_DIR/modules/prompt.sh" "$REPO_URL/modules/prompt.sh" &&
    curl -sS -o "$INSTALL_DIR/modules/systems.sh" "$REPO_URL/modules/systems.sh"
) > /dev/null 2>&1 &
spinner $! "Downloading scripts..."

# Add to shell profile
echo "○ Update shell profile"
SHELL_RC="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q 'kickstart.sh' "$SHELL_RC"; then
    # Add multiline content to shell profile
    (
        cat <<EOF >>"$SHELL_RC"

# Kickstarter
source $INSTALL_DIR/kickstart.sh

EOF
    ) >/dev/null 2>&1 &
    spinner $! "Updating shell profile..."
else
    echo -e "\n\033[34m✓ Profile already contains kickstart.sh\033[0m\n"
fi
source "$SHELL_RC"

# Cleanup
echo "\n\033[1;32m✓ Done\033[0m Kickstarter installed successfully\n"
# rm "$INSTALL_DIR/install.sh"
