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

set -e # Enable exit on error

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Update the system
echo "\n\033[90m○ Updating system...\033[0m\n"
(sudo apt-get update && sudo apt-get upgrade -y) > /dev/null 2>&1 &
spinner $!
echo "\n\033[1;32m✓ Done\033[0m System updated\n"

# Install essential packages
echo "\n\033[90m○ Installing essential packages...\033[0m\n"
(sudo apt-get install -y "${ESSENTIAL_PACKAGES[@]}") > /dev/null 2>&1 &
spinner $!
echo "\n\033[1;32m✓ Done\033[0m Essential packages installed\n"

# Create installation directory
mkdir -p "$INSTALL_DIR/modules"
echo "\n\033[1;32m✓ Done\033[0m Directory created\n"

# Download scripts
echo "\n\033[90m○ Downloading scripts...\033[0m\n"
(curl -sS -o "$INSTALL_DIR/kickstart.sh" "$REPO_URL/kickstart.sh" && \
 curl -sS -o "$INSTALL_DIR/modules/packages.sh" "$REPO_URL/modules/packages.sh" && \
 curl -sS -o "$INSTALL_DIR/modules/messages.sh" "$REPO_URL/modules/messages.sh" && \
 curl -sS -o "$INSTALL_DIR/modules/prompt.sh" "$REPO_URL/modules/prompt.sh" && \
 curl -sS -o "$INSTALL_DIR/modules/systems.sh" "$REPO_URL/modules/systems.sh") > /dev/null 2>&1 &
spinner $!
echo "\n\033[1;32m✓ Done\033[0m Script downloaded\n"

# Add to shell profile
echo "\n\033[90m○ Update shell profile...\033[0m\n"
SHELL_RC="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && SHELL_RC="$HOME/.zshrc"

if ! grep -q 'kickstart.sh' "$SHELL_RC"; then
    echo "source $INSTALL_DIR/kickstart.sh" >> "$SHELL_RC"
fi

source "$SHELL_RC"
echo "\n\033[1;32m✓ Done\033[0m Shell profile updated\n"

# Cleanup
echo "\n\033[1;32m✓ Done\033[0m Kickstarter installed successfully\n"
rm "$INSTALL_DIR/install.sh"