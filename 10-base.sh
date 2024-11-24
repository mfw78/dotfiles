# Base packages
AddPackage amd-ucode # Microcode update image for AMD CPUs
AddPackage base # Minimal package set to define a basic Arch Linux installation
AddPackage btrfs-progs # Btrfs filesystem utilities
AddPackage dosfstools # DOS filesystem utilities
AddPackage efibootmgr # Linux user-space application to modify the EFI Boot Manager
AddPackage exfatprogs # exFAT filesystem userspace utilities for the Linux Kernel exfat driver
AddPackage libpwquality # Library for password quality checking and generating random passwords
AddPackage linux # The Linux kernel and modules
AddPackage linux-firmware # Firmware files for Linux
AddPackage ntp # Network Time Protocol reference implementation
AddPackage lvm2 # Logical Volume Manager 2 utilities
AddPackage sudo # Give certain users the ability to run some commands as root
AddPackage usbutils # A collection of USB tools to query connected USB devices
AddPackage zip # Compressor/archiver for creating and modifying zipfiles

CreateFile /etc/.pwd.lock 600 > /dev/null
CopyFile /etc/group
CopyFile /etc/group-
CopyFile /etc/gshadow
CopyFile /etc/gshadow- 600
CopyFile /etc/pam.d/passwd
CreateLink /etc/localtime /usr/share/zoneinfo/UTC
CopyFile /etc/passwd
CopyFile /etc/passwd-
CopyFile /etc/shadow
CopyFile /etc/shadow- 600
CopyFile /etc/subgid
CreateFile /etc/subgid- > /dev/null
CopyFile /etc/subuid
CreateFile /etc/subuid- > /dev/null
CopyFile /etc/mkinitcpio.d/linux.preset

# Specify locales
f="$(GetPackageOriginalFile glibc /etc/locale.gen)"
sed -i 's/^#\(en_AU.UTF-8\)/\1/g' "$f"
sed -i 's/^#\(en_US.UTF-8\)/\1/g' "$f"
RemoveFile /etc/locale.gen

# Set the system locale
echo 'LANG=en_AU.UTF-8' > "$(CreateFile /etc/locale.conf)"
echo 'KEYMAP=us' > "$(CreateFile /etc/vconsole.conf)"

# Set the sudoers file to allow wheel group members to run sudo
f="$(GetPackageOriginalFile sudo /etc/sudoers)"
sed -i 's/^# \(%wheel ALL=(ALL:ALL) ALL\)/\1/g' "$f"

# Allow parallel package downloads
f="$(GetPackageOriginalFile pacman /etc/pacman.conf)"
sed -i 's/^#\(ParallelDownloads = 5\)/\1/g' "$f"

# Allow other users to mount fuse filesystems
f="$(GetPackageOriginalFile fuse-common /etc/fuse.conf)"
sed -i 's/^#\(user_allow_other\)/\1/g' "$f"

# Write the hostname
echo "$HOSTNAME" > "$(CreateFile /etc/hostname)"

# Set the hosts file
f="$(GetPackageOriginalFile filesystem /etc/hosts)"
echo "127.0.0.1 $HOSTNAME $HOSTNAME.localdomain" > "$f"

# Set the resolv.conf file
f="$(GetPackageOriginalFile filesystem /etc/resolv.conf)"
echo 'nameserver 127.0.0.1' >> "$f"

# Configure reflector
f="$(GetPackageOriginalFile reflector /etc/xdg/reflector/reflector.conf)"
sed -i 's/\(--sort \)age/\1rate/' "$f"
CreateLink /etc/systemd/system/timers.target.wants/reflector.timer /usr/lib/systemd/system/reflector.timer

# Load the nct6775 kernel module for use with lm_sensors
cat >> "$(CreateFile /etc/modules-load.d/nct6775.conf)" <<EOF
# Load sensors for lm-sensors
nct6775
EOF
CreateLink /etc/systemd/system/multi-user.target.wants/lm_sensors.service /usr/lib/systemd/system/lm_sensors.service

# Boot configurations
if [[ "$HOSTNAME" == "anouk" ]]
then
    # Configure the mkinitcpio.conf file
    f="$(GetPackageOriginalFile mkinitcpio /etc/mkinitcpio.conf)"
    sed -i 's/^MODULES=().*/MODULES=(usbhid xhci_hcd dm-raid dm_integrity raid0 raid1)/' "$f"
    sed -i 's/^HOOKS=.*/HOOKS=(systemd autodetect microcode modconf kms block mdadm_udev keyboard sd-vconsole sd-encrypt lvm2 filesystems fsck)/' "$f"

    # Set the crypttab for initramfs and fstab
    CopyFileTo "/etc/crypttab.initramfs-$HOSTNAME" "/etc/crypttab.initramfs" 600
    CopyFileTo "/etc/fstab-$HOSTNAME" "/etc/fstab"
fi

# TPM 2.0
AddPackage tpm2-abrmd # Trusted Platform Module 2.0 Access Broker and Resource Management Daemon
AddPackage tpm2-tools # Trusted Platform Module 2.0 tools based on tpm2-tss
CreateLink /etc/systemd/system/multi-user.target.wants/tpm2-abrmd.service /usr/lib/systemd/system/tpm2-abrmd.service

# Misc
CreateLink /etc/systemd/system/getty.target.wants/getty@tty1.service /usr/lib/systemd/system/getty@.service

# https://gitlab.archlinux.org/archlinux/packaging/packages/shadow/-/commit/8d04a87d0b943e4e0ffbb91d1e59d1009d85e63b
SetFileProperty /usr/bin/groupmems group groups
SetFileProperty /usr/bin/groupmems mode 2750
SetFileProperty /usr/lib/utempter/utempter group utmp
SetFileProperty /usr/lib/utempter/utempter mode 2755

# Generate the locale
sudo locale-gen