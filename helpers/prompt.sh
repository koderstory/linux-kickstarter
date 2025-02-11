source "$INSTALL_DIR/helpers/messages.sh"

# Fungsi untuk membuat pilihan dinamis dari array
generate_options() {
    local -n choices=$1  # Gunakan referensi ke array
    local options=()
    
    for i in "${!choices[@]}"; do
        options+=("$((i+1))" "${choices[i]}" "OFF")  # Semua default OFF
    done

    echo "${options[@]}"
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
                install "$install_function"
            fi
            break
        else
            print_warning "Invalid input! Please enter 'y' or 'n'"
        fi
    done
}