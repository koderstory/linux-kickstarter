source "$INSTALL_DIR/helpers/messages.sh"

# Instalasi codecs berdasarkan distro
get_bundle_package_media_codecs() {
    print_info "Installing media codecs..."
    case "$DISTRO" in
    ubuntu | debian)
        echo ubuntu-restricted-extras
        ;;
    linuxmint)
        echo mint-meta-codecs
        ;;
    fedora)
        echo gstreamer1-plugins-bad gstreamer1-plugins-ugly gstreamer1-libav
        ;;
    arch | manjaro)
        echo gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav
        ;;
    opensuse*)
        echo zypper install -y ffmpeg vlc-codecs
        ;;
    *)
        echo "Distro tidak dikenali atau tidak didukung"
        exit 1
        ;;
    esac
    print_success "Media codecs installed successfully"
}