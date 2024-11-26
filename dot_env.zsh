# Use GPG for SSH authentication
unset SSH_AGENT_PID
# Set `SSH_AUTH_SOCK` to point to gpg-agent's SSH socket
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
# Optionally check if gpg-agent should be used based on the parent process
if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

# Set the default editor to neovim
export EDITOR=$(which nvim)

