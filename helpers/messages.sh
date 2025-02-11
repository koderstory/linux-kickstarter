# ===================================================================================
# Functions to print colored messages
# ===================================================================================
message_success() {
    echo -e "\n\033[1;32m✓ Done\033[0m $1\n"
}

message_info() {
    echo -e "\n\033[1;36mℹ Info\033[0m $1\n"
}

message_warning() {
    echo -e "\n\033[1;33m⚠ Warning\033[0m $1\n"
}

message_error() {
    echo -e "\n\033[1;31m⨯ Error\033[0m $1\n"
}