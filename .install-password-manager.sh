#!/bin/sh

# Ensure arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <GPG_KEY_EMAIL> <PASSWORD_STORE_REPO>"
    exit 1
fi

# Parameters
GPG_KEY_EMAIL="$1"
PASSWORD_STORE_REPO="$2"

# Check if pass is installed
is_pass_installed() {
    type pass >/dev/null 2>&1
}

# Check if GPG key exists for the specified email
is_gpg_key_present() {
    gpg --list-keys "$GPG_KEY_EMAIL" >/dev/null 2>&1
}

# Fast exit if all conditions are met
if is_pass_installed && [ -d "$HOME/.password-store" ] && is_gpg_key_present; then
    exit 0
fi

# Install `pass` if not installed
install_pass() {
    if ! is_pass_installed; then
        if [ -x "$(command -v pacman)" ]; then
            echo "Installing 'pass'..."
            sudo pacman -Sy --noconfirm pass
        else
            echo "Unsupported package manager. Only pacman is supported."
            exit 1
        fi
    fi
}

# Search and trust the GPG key by email address
search_and_trust_gpg_key() {
    if is_gpg_key_present; then
        return
    fi

    echo "Searching for GPG keys for $GPG_KEY_EMAIL..."
    gpg --keyserver "keyserver.ubuntu.com" --search-keys "$GPG_KEY_EMAIL"

    if [ $? -ne 0 ]; then
        echo "Failed to search for GPG key. Check your email or keyserver."
        exit 1
    fi

    IMPORTED_KEY_ID=$(gpg --list-keys --with-colons "$GPG_KEY_EMAIL" | awk -F: '/^pub:/ {print $5}')
    if [ -z "$IMPORTED_KEY_ID" ]; then
        echo "Failed to retrieve the imported GPG key ID."
        exit 1
    fi

    echo "Marking GPG key $IMPORTED_KEY_ID as ultimately trusted..."
    echo -e "trust\n5\ny\n" | gpg --command-fd 0 --edit-key "$IMPORTED_KEY_ID"
}

# Check for YubiKey and bind GPG subkeys
bind_gpg_yubikey() {
    while ! gpg --card-status >/dev/null 2>&1; do
        echo "Insert your YubiKey and press Enter."
        read -r
    done

    gpg --card-status >/dev/null
}

# Clone password store repository using GPG for SSH
clone_password_store() {
    if [ ! -d "$HOME/.password-store" ]; then
        echo "Cloning password store repository..."
        export GPG_TTY=$(tty)
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

        if ! git clone --recurse-submodules "$PASSWORD_STORE_REPO" "$HOME/.password-store"; then
            echo "Failed to clone repository. Check your GPG authentication."
            exit 1
        fi
    fi
}

# Main script logic
if [ "$(uname -s)" != "Linux" ]; then
    echo "Unsupported OS. This script supports Linux only."
    exit 1
fi

install_pass
search_and_trust_gpg_key
bind_gpg_yubikey
clone_password_store
