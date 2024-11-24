CopyFile /etc/systemd/network/20-wired.network

# systemd-networkd configuration
CreateLink /etc/systemd/system/dbus-org.freedesktop.network1.service /usr/lib/systemd/system/systemd-networkd.service
CreateLink /etc/systemd/system/multi-user.target.wants/systemd-networkd.service /usr/lib/systemd/system/systemd-networkd.service
CreateLink /etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service /usr/lib/systemd/system/systemd-networkd-wait-online.service
CreateLink /etc/systemd/system/sockets.target.wants/systemd-networkd.socket /usr/lib/systemd/system/systemd-networkd.socket
CreateLink /etc/systemd/system/sysinit.target.wants/systemd-network-generator.service /usr/lib/systemd/system/systemd-network-generator.service

# Firewall
CreateLink /etc/systemd/system/multi-user.target.wants/iptables.service /usr/lib/systemd/system/iptables.service

# WiFi
CopyFile /etc/systemd/network/25-wireless.network
CreateLink /etc/systemd/system/multi-user.target.wants/iwd.service /usr/lib/systemd/system/iwd.service


# Network services
CreateLink /etc/systemd/system/multi-user.target.wants/dnscrypt-proxy.service /usr/lib/systemd/system/dnscrypt-proxy.service
CreateLink /etc/systemd/system/multi-user.target.wants/nfs-client.target /usr/lib/systemd/system/nfs-client.target
CreateLink /etc/systemd/system/multi-user.target.wants/ntpd.service /usr/lib/systemd/system/ntpd.service
CreateLink /etc/systemd/system/multi-user.target.wants/remote-fs.target /usr/lib/systemd/system/remote-fs.target
CreateLink /etc/systemd/system/multi-user.target.wants/rpcbind.service /usr/lib/systemd/system/rpcbind.service
CreateLink /etc/systemd/system/remote-fs.target.wants/nfs-client.target /usr/lib/systemd/system/nfs-client.target
CreateLink /etc/systemd/system/multi-user.target.wants/sshd.service /usr/lib/systemd/system/sshd.service
