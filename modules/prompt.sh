source "$INSTALL_DIR/modules/messages.sh"

# Fungsi untuk membuat pilihan dinamis dari array
generate_options() {
    local -n choices=$1  # Gunakan referensi ke array
    local options=()
    
    for i in "${!choices[@]}"; do
        options+=("$((i+1))" "${choices[i]}" "OFF")  # Semua default OFF
    done

    echo "${options[@]}"
}