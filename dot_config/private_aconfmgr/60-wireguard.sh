#!/bin/bash

# Function to get a value for a key from password-store
GetPasswordStoreField() {
    local host="$1"
    local field="$2"
    local value
    value=$(pass show "Network/WireGuard/$host" 2>/dev/null | grep "^$field:" | awk -F': ' '{print $2}' || true)
    if [[ -z $value && "$field" != "endpoint" ]]; then
        return 1
    fi
    echo "$value"
}

# Function to generate a peer configuration
GeneratePeerConfig() {
    local host="$1"
    local current_host_endpoint="$2"
    local public_key allowed_ips endpoint

    public_key=$(GetPasswordStoreField "$host" "public_key") || return 1
    allowed_ips=$(GetPasswordStoreField "$host" "allowed_ips") || return 1
    endpoint=$(GetPasswordStoreField "$host" "endpoint") # Optional field

    # Determine the appropriate PersistentKeepalive value
    local keepalive
    if [[ -z $current_host_endpoint || -z $endpoint ]]; then
        keepalive=5
    else
        keepalive=25
    fi

    # Generate peer configuration
    {
        echo "# Peer: $host"
        echo "[Peer]"
        echo "PublicKey=$public_key"
        echo "AllowedIPs=$allowed_ips"
        [[ -n $endpoint ]] && echo "Endpoint=$endpoint"
        echo "PersistentKeepalive=$keepalive"
        echo
    }
}

# Main function to generate the WireGuard configuration
GenerateWireGuardConfig() {
    local current_host="$1"
    local config_name="$2"
    shift 2
    local peers=("$@")
    local username="${peers[-1]}"
    unset 'peers[-1]'

    local private_key address current_host_endpoint config_content

    private_key=$(pass show "Network/WireGuard/$current_host" | head -n 1) || return 1
    address=$(GetPasswordStoreField "$current_host" "address") || return 1
    current_host_endpoint=$(GetPasswordStoreField "$current_host" "endpoint") # Optional field

    # Build the configuration in memory
    config_content=$(cat <<EOF
[Interface]
Address=$address
EOF
)
    # Add ListenPort and PrivateKey if the current host has an endpoint
    if [[ -n $current_host_endpoint ]]; then
        config_content+=$(cat <<EOF

ListenPort=51820
PrivateKey=$private_key

# Add a dummy interface to ensure br0 is up
PostUp=ip route add default via 10.30.0.254 dev wg0 table 200; \
       iptables -t mangle -A PREROUTING -i br0 -j MARK --set-mark 1; \
       iptables -t nat -A POSTROUTING -o wg0 -j MASQUERADE

PostDown=ip route flush table 200; \
         iptables -t mangle -D PREROUTING -i br0 -j MARK --set-mark 1; \
         iptables -t nat -D POSTROUTING -o wg0 -j MASQUERADE
EOF
)
    else
        # Use PostUp for roaming machines
        config_content+=$(cat <<EOF

PostUp=wg set %i private-key <(su $username -c "export PASSWORD_STORE_DIR=/home/$username/.password-store/; pass Network/WireGuard/$current_host")
EOF
)
    fi

    # Special case: If the current host is 'anouk', set Table=off
    if [[ "$current_host" == "anouk" ]]; then
        config_content+=$(cat <<EOF

# Special case for anouk
Table=off
EOF
)
    fi

    # Add peer configurations with newlines between each peer
    for peer in "${peers[@]}"; do
        [[ "$peer" == "$current_host" ]] && continue
        peer_config=$(GeneratePeerConfig "$peer" "$current_host_endpoint") || continue
        config_content+=$'\n\n'"$peer_config"
    done

    # Write the configuration to the file
    cat > "$(CreateFile "/etc/wireguard/${config_name}.conf")" <<< "$config_content"
}

# Example usage
peers=("anouk" "registry" "site-01" "achilles")
username="mfw78"
GenerateWireGuardConfig "$HOSTNAME" "wg0" "${peers[@]}" "$username"

CreateLink /etc/systemd/system/multi-user.target.wants/wg-quick@wg0.service /usr/lib/systemd/system/wg-quick@.service
