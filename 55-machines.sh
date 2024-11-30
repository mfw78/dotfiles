#!/bin/bash

# Variables
BRIDGE_NAME="br0"
BRIDGE_IP="192.168.2.254/24"
CONTAINER_NAME="blockchains"
CONTAINER_GATEWAY="192.168.2.1"
ROUTE_DEST="172.20.0.0/16"
DEVICE_ALLOW_PATH="/etc/systemd/system.control/systemd-nspawn@${CONTAINER_NAME}.service.d"
SERVICE_OVERRIDE_PATH="/etc/systemd/system/systemd-nspawn@${CONTAINER_NAME}.service.d"
WG_INTERFACE="wg0"

# Function to create a systemd network bridge
CreateBridge() {
    local bridge_name="$1"
    local bridge_ip="$2"
    local gateway="$3"
    local route_dest="$4"

    cat > "$(CreateFile /etc/systemd/network/25-${bridge_name}.netdev)" <<EOF
[NetDev]
Name=${bridge_name}
Kind=bridge
EOF

    cat > "$(CreateFile /etc/systemd/network/25-${bridge_name}.network)" <<EOF
[Match]
Name=${bridge_name}

[Network]
Address=${bridge_ip}

[Route]
Gateway=${gateway}
Destination=${route_dest}
EOF
}

# Function to configure the container
ConfigureContainer() {
    local container_name="$1"
    local bridge_name="$2"

    cat > "$(CreateFile /etc/systemd/nspawn/${container_name}.nspawn)" <<EOF
[Exec]
SystemCallFilter=add_key keyctl bpf
PrivateUsers=no

[Files]
Bind=/data
Bind=/code/${container_name}
Bind=/dev/fuse
Bind=/proc:/run/proc
Bind=/sys:/run/sys

[Network]
Bridge=${bridge_name}
EOF
}

# Function to configure device allow list
ConfigureDeviceAllow() {
    local device_allow_path="$1"

    cat > "$(CreateFile ${device_allow_path}/50-DeviceAllow.conf)" <<EOF
[Service]
DeviceAllow=
DeviceAllow=/dev/fuse rwm
DeviceAllow=block-device-mapper rw
DeviceAllow=/dev/mapper/control rw
DeviceAllow=block-blkext rw
DeviceAllow=block-loop rw
DeviceAllow=/dev/loop-control rw
DeviceAllow=char-pts rw
DeviceAllow=/dev/net/tun rwm
EOF
}

# Function to configure the fwmark rules
ConfigureFwmarkRules() {
    cat > "$(CreateFile /etc/systemd/system/fwmark-rules.service)" <<EOF
[Unit]
Description=Persistent fwmark routing rule
Requires=systemd-nspawn@${CONTAINER_NAME}.service
After=systemd-nspawn@${CONTAINER_NAME}.service

[Service]
Type=oneshot
ExecStart=/usr/bin/ip rule add fwmark 1 table 200
ExecStop=/usr/bin/ip rule del fwmark 1 table 200
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
}

# Function to configure service override for systemd-nspawn
ConfigureServiceOverride() {
    local service_override_path="$1"
    local wg_interface="$2"
    local bridge_name="$3"
    local route_dest="$4"
    local gateway="$5"

    cat > "$(CreateFile ${service_override_path}/override.conf)" <<EOF
[Unit]
Requires=wg-quick@${wg_interface}.service
After=wg-quick@${wg_interface}.service
Wants=fwmark-rules.service

[Service]
Environment=SYSTEMD_SECCOMP=0

# Add forwarding rules between ${wg_interface} and ${bridge_name}
ExecStartPost=/usr/bin/iptables -A FORWARD -i ${wg_interface} -d ${route_dest} -j ACCEPT
ExecStartPost=/usr/bin/iptables -A FORWARD -s ${route_dest} -i ${bridge_name} -j ACCEPT

# Clean up rules when stopping the container
ExecStopPost=/usr/bin/iptables -D FORWARD -i ${wg_interface} -d ${route_dest} -j ACCEPT
ExecStopPost=/usr/bin/iptables -D FORWARD -s ${route_dest} -i ${bridge_name} -j ACCEPT
EOF
}

# Main logic
if [[ "$HOSTNAME" == "anouk" ]]; then
    # Configure the bridge network
    CreateBridge "$BRIDGE_NAME" "$BRIDGE_IP" "$CONTAINER_GATEWAY" "$ROUTE_DEST"

    # Configure the container
    ConfigureContainer "$CONTAINER_NAME" "$BRIDGE_NAME"

    # Configure device allow list for the container service
    ConfigureDeviceAllow "$DEVICE_ALLOW_PATH"

    # Configure service override with forwarding rules and dependency
    ConfigureServiceOverride "$SERVICE_OVERRIDE_PATH" "$WG_INTERFACE" "$BRIDGE_NAME" "$ROUTE_DEST" "$CONTAINER_GATEWAY"

    # Configure fwmark rules
    ConfigureFwmarkRules

    # Create symlink for the container service
    CreateLink "/etc/systemd/system/machines.target.wants/systemd-nspawn@${CONTAINER_NAME}.service" \
               "/usr/lib/systemd/system/systemd-nspawn@.service"
fi
