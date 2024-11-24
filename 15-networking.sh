# Fixed machines run on systemd-networkd
if [[ "$HOSTNAME" == "anouk" ]]
then
    # Configure systemd-network

    # Wired network
    cat >> "$(CreateFile /etc/systemd/network/20-wired.network)" <<EOF
[Match]
Name=en*

[Network]
DHCP=yes
IgnoreCarrierLoss=3s
EOF

    # systemd-networkd configuration
    CreateLink /etc/systemd/system/dbus-org.freedesktop.network1.service /usr/lib/systemd/system/systemd-networkd.service
    CreateLink /etc/systemd/system/multi-user.target.wants/systemd-networkd.service /usr/lib/systemd/system/systemd-networkd.service
    CreateLink /etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service /usr/lib/systemd/system/systemd-networkd-wait-online.service
    CreateLink /etc/systemd/system/sockets.target.wants/systemd-networkd.socket /usr/lib/systemd/system/systemd-networkd.socket
    CreateLink /etc/systemd/system/sysinit.target.wants/systemd-network-generator.service /usr/lib/systemd/system/systemd-network-generator.service

    # WiFi
    cat >> "$(CreateFile /etc/systemd/network/25-wireless.network)" <<EOF
[Match]
Name=wlan0

[Network]
DHCP=yes
IgnoreCarrierLoss=3s
EOF
    CreateLink /etc/systemd/system/multi-user.target.wants/iwd.service /usr/lib/systemd/system/iwd.service

    # Fixed machines also run SSH by default
    CreateLink /etc/systemd/system/multi-user.target.wants/sshd.service /usr/lib/systemd/system/sshd.service

elif [[ "$HOSTNAME" == "achilles" ]]
then
    AddPackage networkmanager # Network connection manager and user applications
    AddPackage util-linux # Miscellaneous system utilities for Linux (i.e. RFKill)

    CreateLink /etc/systemd/system/dbus-org.freedesktop.nm-dispatcher.service /usr/lib/systemd/system/NetworkManager-dispatcher.service
    CreateLink /etc/systemd/system/multi-user.target.wants/NetworkManager.service /usr/lib/systemd/system/NetworkManager.service
    CreateLink /etc/systemd/system/network-online.target.wants/NetworkManager-wait-online.service /usr/lib/systemd/system/NetworkManager-wait-online.service
    CreateLink /etc/systemd/system/systemd-networkd.service /dev/null
fi

# Firewall
CreateLink /etc/systemd/system/multi-user.target.wants/iptables.service /usr/lib/systemd/system/iptables.service

# Network services
CreateLink /etc/systemd/system/multi-user.target.wants/dnscrypt-proxy.service /usr/lib/systemd/system/dnscrypt-proxy.service
CreateLink /etc/systemd/system/multi-user.target.wants/nfs-client.target /usr/lib/systemd/system/nfs-client.target
CreateLink /etc/systemd/system/multi-user.target.wants/ntpd.service /usr/lib/systemd/system/ntpd.service
CreateLink /etc/systemd/system/multi-user.target.wants/remote-fs.target /usr/lib/systemd/system/remote-fs.target
CreateLink /etc/systemd/system/multi-user.target.wants/rpcbind.service /usr/lib/systemd/system/rpcbind.service
CreateLink /etc/systemd/system/remote-fs.target.wants/nfs-client.target /usr/lib/systemd/system/nfs-client.target
