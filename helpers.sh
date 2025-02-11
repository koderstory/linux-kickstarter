source msg_printer.sh

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "Unknown"
    fi
}

# Instalasi codecs berdasarkan distro
install_media_codecs() {
    print_info "Installing media codecs..."
    case "$DISTRO" in
    ubuntu | debian)
        sudo apt update && sudo apt install -y ubuntu-restricted-extras
        ;;
    linuxmint)
        sudo apt update && sudo apt install -y mint-meta-codecs
        ;;
    fedora)
        sudo dnf install -y gstreamer1-plugins-bad gstreamer1-plugins-ugly gstreamer1-libav
        ;;
    arch | manjaro)
        sudo pacman -S --noconfirm gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
        ;;
    opensuse*)
        sudo zypper install -y ffmpeg vlc-codecs
        ;;
    void)
        sudo xbps-install -S ffmpeg gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad
        ;;
    *)
        echo "Distro tidak dikenali atau tidak didukung"
        exit 1
        ;;
    esac
    print_success "Media codecs installed successfully"
}

# Fungsi untuk membuat pilihan dinamis dari array
generate_options() {
    local -n choices=$1  # Gunakan referensi ke array
    local options=()
    
    for i in "${!choices[@]}"; do
        options+=("$((i+1))" "${choices[i]}" "OFF")  # Semua default OFF
    done

    echo "${options[@]}"
}

# Fungsi untuk instalasi
install() {
    print_info "Installing..."
    eval "$1"
    print_success "Installation completed successfully"
}

# Fungsi untuk prompt pilihan instalasi
prompt_installation() {
    local prompt_message="$1"
    local default_choice="$2"
    local install_function="$3"

    while true; do
        read -p "$prompt_message [$default_choice] " -n 1 -r
        echo # Pindah baris setelah input

        # Set default jika tidak ada input
        REPLY="${REPLY:-$default_choice}"

        if [[ $REPLY =~ ^[yYnN]$ ]]; then
            if [[ $REPLY =~ ^[yY]$ ]]; then
                install "$install_function"
            fi
            break
        else
            print_warning "Invalid input! Please enter 'y' or 'n'"
        fi
    done
}

from_array() {
    sudo apt install -y "$@"
}

install_docker() {
    # Add Docker's official GPG key
    # sudo install -m 0755 -d /etc/apt/keyrings
    # sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    # sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    # echo \
    #     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    # $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
    #     sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    # sudo apt-get update

    # Install Docker
    # sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    print_success "Docker installed successfully"
}