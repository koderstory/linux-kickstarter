source "$INSTALL_DIR/helpers/messages.sh"

# Fungsi untuk instalasi
install() {
    print_info "Installing..."
    local packages=$1
    case "$DISTRO" in
    debian | ubuntu | linuxmint)
        sudo apt install -y "$packages[@]"
        ;;
    fedora)
        sudo dnf install -y "$packages[@]"
        ;;
    arch | manjaro)
        sudo pacman -S --noconfirm "$packages[@]"
        ;;
    opensuse*)
        sudo zypper install -y "$packages[@]"
        ;;
    *)
        echo "Distro tidak dikenali atau tidak didukung"
        exit 1
        ;;
    esac
    print_success "Installation completed successfully"
}

from_array() {
    sudo apt install -y "$@"
}
