source "$KICKSTARTER_DIR/modules/messages.sh"

# Fungsi untuk instalasi
install() {
    print_info "Installing..."
    local packages=$1
    case "$DISTRO" in
    debian | ubuntu | linuxmint)
        sudo apt install -y "${packages[@]}"
        ;;
    fedora)
        sudo dnf install -y "${packages[@]}"
        ;;
    arch | manjaro)
        sudo pacman -S --noconfirm "${packages[@]}"
        ;;
    opensuse*)
        sudo zypper install -y "${packages[@]}"
        ;;
    *)
        echo "Distro tidak dikenali atau tidak didukung"
        exit 1
        ;;
    esac
    print_success "Installation completed successfully"
}

# Fungsi untuk prompt pilihan instalasi
with_prompt() {
    local install_function="$1"
    local prompt_message="$2"
    local default_choice="$3"

    while true; do
        read -p "$prompt_message [$default_choice] " -n 1 -r
        echo # Pindah baris setelah input

        # Set default jika tidak ada input
        REPLY="${REPLY:-$default_choice}"

        if [[ $REPLY =~ ^[yYnN]$ ]]; then
            if [[ $REPLY =~ ^[yY]$ ]]; then
                eval "$install_function"
            fi
            break
        else
            print_warning "Invalid input! Please enter 'y' or 'n'"
        fi
    done
}