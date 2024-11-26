# Function to set SSH_AUTH_SOCK for gpg-agent's SSH socket
set_gpg_agent_ssh_socket() {
    # Set SSH_AUTH_SOCK to gpg-agent's SSH socket
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
}

# Use GPG for SSH authentication
unset SSH_AGENT_PID

# If this is an SSH session, handle forwarding
if [[ -n "$SSH_CONNECTION" ]]; then
    # For SSH connections, use the forwarded SSH_AUTH_SOCK if available
    if [[ -S "$SSH_AUTH_SOCK" ]]; then
        export SSH_AUTH_SOCK=$SSH_AUTH_SOCK
    else
        # Fallback to gpg-agent's SSH socket
        set_gpg_agent_ssh_socket
    fi
else
    # If this is a local session (not SSH), use the local GPG agent's SSH socket
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
    # Optionally check if gpg-agent should be used based on the parent process
    if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
        set_gpg_agent_ssh_socket
    fi
fi

# Set the default editor to neovim
export EDITOR=$(which nvim)

