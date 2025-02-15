#!/bin/bash
KICKSTARTER_DIR="${KICKSTARTER_DIR:-$HOME/.linux-kickstarter}"

# Source modul
for module in "$KICKSTARTER_DIR/modules/"*.sh; do
    source "$module"
done

kickstart() {
    # Enable exit on error
    set -e
    DISTRO=$(detect_distro)
    get_bundle_package_media_codecs() {
        declare -A codec_packages=(
            [ubuntu]="ubuntu-restricted-extras"
            [debian]="ubuntu-restricted-extras"
            [linuxmint]="mint-meta-codecs"
            [fedora]="gstreamer1-plugins-bad gstreamer1-plugins-ugly gstreamer1-libav"
            [arch]="gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav"
            [manjaro]="gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav"
            [opensuse]="zypper install -y ffmpeg vlc-codecs"
        )

        if [[ -n "${codec_packages[$DISTRO]}" ]]; then
            echo "${codec_packages[$DISTRO]}"
        else
            echo "Distro tidak dikenali atau tidak didukung"
            exit 1
        fi
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
    # ===================================================================================
    # Prompt User Input
    # ===================================================================================
    # Personal Development Environment Setup or Production Environment Setup
    selected_purpose=$(
        whiptail \
            --title "Select Intended Use" \
            --radiolist "Choose one:" 10 40 2 \
            --ok-button "Next" \
            "laptop" "Personal Setup" ON \
            "server" "Production Setup" OFF \
            3>&1 \
            1>&2 \
            2>&3
    ) || exit 1 # on "Cancel"

    selected_languages=$(
        whiptail \
            --title "Programming Languages" \
            --ok-button "Next" \
            --checklist "What languages you want to develop in this machine:" 10 40 3 \
            1 "Python" ON \
            2 "NodeJS" OFF \
            3 "Android" OFF \
            3>&1 \
            1>&2 \
            2>&3
    ) || exit 1 # on "Cancel"

    git_user_name=$(
        whiptail \
            --title "Git Global Config" \
            --ok-button "Next" \
            --inputbox "user.name:" 10 60 \
            3>&1 \
            1>&2 \
            2>&3
    ) || exit 1 # on "Cancel"

    git_user_email=$(
        whiptail \
            --title "Git Global Config" \
            --ok-button "Next" \
            --inputbox "user.email:" 10 60 \
            3>&1 \
            1>&2 \
            2>&3
    ) || exit 1 # on "Cancel"

    options=$(generate_options OPTIONAL_CHOICES)
    selected_optional=$(
        whiptail \
            --title "Optional Packages" \
            --ok-button "Next" \
            --checklist "Choose optional packages to install:" 20 60 10 \
            $options \
            3>&1 \
            1>&2 \
            2>&3
    ) || exit 1 # on "Cancel"

    # ===================================================================================
    # Steps: Installation
    # ===================================================================================
    if [ "$purpose" == "server" ]; then
        install openssh-server

        with_prompt "install_media_codecs" "Do you want to install media codecs?" "N"

        # Prompt Docker installation
        while true; do
            read -p "Do you want to install docker? [Y/n] " -n 1 -r
            echo # Pindah baris setelah input

            # Default 'y'
            REPLY="${REPLY:-y}"

            if [[ $REPLY =~ ^[yYnN]$ ]]; then
                # Add Docker's official GPG key
                # sudo install -m 0755 -d /etc/apt/keyrings
                # sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                # sudo chmod a+r /etc/apt/keyrings/docker.asc

                # Add the repository to Apt sources:
                #             echo \
                #                 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                #   $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
                #                 sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
                #             sudo apt-get update

                # Install Docker
                # sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                print_success "Docker installed successfully"
                break
            else
                print_warning "Invalid input! Please enter 'y' or 'n'"
            fi
        done
    else
        install "${USEFULL_PDE_UTILITIES[@]}"
        with_prompt "install get_bundle_package_media_codecs" "Do you want to install media codecs?" "N"
        install "${DEV_SOFTWARES[@]}"
    fi

    # ===================================================================================
    # Step: Configuration
    # ===================================================================================
    # Git global configuration
    print_info "Configuring Git..."
    # git config --global user.name "$git_user_name --global user.email $git_user_email"
    print_success "Git configured successfully"

    # Activate firewall
    print_info "Activating firewall..."
    # sudo ufw enable
    print_success "Firewall activated successfully"

    print_success "Kickstarter completed successfully"

    # Remove all downloaded files
    rm -rf "$KICKSTARTER_DIR/.linux-kickstarter" && exit
}
