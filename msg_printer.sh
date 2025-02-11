# ===================================================================================
# Functions to print colored messages
# ===================================================================================
print_success() {
    echo -e "\n\033[1;32m✓ Done\033[0m $1\n"
}

print_info() {
    echo -e "\n\033[1;36mℹ Info\033[0m $1\n"
}

print_warning() {
    echo -e "\n\033[1;33m⚠ Warning\033[0m $1\n"
}

print_error() {
    echo -e "\n\033[1;31m⨯ Error\033[0m $1\n"
}