
CopyFile /etc/systemd/network/20-wired.network
CopyFile /etc/systemd/network/25-wireless.network
CreateLink /etc/systemd/system/dbus-org.freedesktop.network1.service /usr/lib/systemd/system/systemd-networkd.service
CreateLink /etc/systemd/system/getty.target.wants/getty@tty1.service /usr/lib/systemd/system/getty@.service
CreateLink /etc/systemd/system/multi-user.target.wants/dnscrypt-proxy.service /usr/lib/systemd/system/dnscrypt-proxy.service
CreateLink /etc/systemd/system/multi-user.target.wants/iptables.service /usr/lib/systemd/system/iptables.service
CreateLink /etc/systemd/system/multi-user.target.wants/iwd.service /usr/lib/systemd/system/iwd.service
CreateLink /etc/systemd/system/multi-user.target.wants/lm_sensors.service /usr/lib/systemd/system/lm_sensors.service
CreateLink /etc/systemd/system/multi-user.target.wants/nfs-client.target /usr/lib/systemd/system/nfs-client.target
CreateLink /etc/systemd/system/multi-user.target.wants/ntpd.service /usr/lib/systemd/system/ntpd.service
CreateLink /etc/systemd/system/multi-user.target.wants/remote-fs.target /usr/lib/systemd/system/remote-fs.target
CreateLink /etc/systemd/system/multi-user.target.wants/rpcbind.service /usr/lib/systemd/system/rpcbind.service
CreateLink /etc/systemd/system/multi-user.target.wants/sshd.service /usr/lib/systemd/system/sshd.service
CreateLink /etc/systemd/system/multi-user.target.wants/systemd-networkd.service /usr/lib/systemd/system/systemd-networkd.service
CreateLink /etc/systemd/system/multi-user.target.wants/taskchampion-sync-server.service /usr/lib/systemd/system/taskchampion-sync-server.service
CreateLink /etc/systemd/system/multi-user.target.wants/tpm2-abrmd.service /usr/lib/systemd/system/tpm2-abrmd.service
CreateLink /etc/systemd/system/multi-user.target.wants/trezord.service /usr/lib/systemd/system/trezord.service
CreateLink /etc/systemd/system/network-online.target.wants/systemd-networkd-wait-online.service /usr/lib/systemd/system/systemd-networkd-wait-online.service
CreateLink /etc/systemd/system/remote-fs.target.wants/nfs-client.target /usr/lib/systemd/system/nfs-client.target
CreateLink /etc/systemd/system/sockets.target.wants/pcscd.socket /usr/lib/systemd/system/pcscd.socket
CreateLink /etc/systemd/system/sockets.target.wants/systemd-networkd.socket /usr/lib/systemd/system/systemd-networkd.socket
CreateLink /etc/systemd/system/sysinit.target.wants/systemd-network-generator.service /usr/lib/systemd/system/systemd-network-generator.service
CreateLink /etc/systemd/system/timers.target.wants/reflector.timer /usr/lib/systemd/system/reflector.timer
CreateLink /etc/udev/rules.d/51-trezor.rules /usr/lib/udev/rules.d/51-trezor.rules

# Sat Nov 23 10:29:16 UTC 2024 - New file properties

SetFileProperty /usr/bin/groupmems group groups
SetFileProperty /usr/bin/groupmems mode 2750
SetFileProperty /usr/lib/utempter/utempter group utmp
SetFileProperty /usr/lib/utempter/utempter mode 2755

sudo locale-gen
