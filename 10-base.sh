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
CopyFile /etc/gshadow
CopyFile /etc/pam.d/passwd
CreateLink /etc/localtime /usr/share/zoneinfo/UTC
CopyFile /etc/passwd
CopyFile /etc/subgid
CreateFile /etc/subgid- > /dev/null
CopyFile /etc/subuid
CreateFile /etc/subuid- > /dev/null
CopyFile /etc/mkinitcpio.d/linux.preset

# Function to retrieve and parse password and salt from pass
get_password_and_salt() {
    local username="$1"
    local password_entry password salt

    # Fetch the password entry from pass
    password_entry=$(pass show "Network/Users/$username") || {
        echo "Error: Could not retrieve entry for $username from pass." >&2
        exit 1
    }

    # Extract the password (first line)
    password=$(echo "$password_entry" | head -n 1)

    # Extract the salt (line starting with 'salt: ')
    salt=$(echo "$password_entry" | grep '^salt:' | sed -E 's/^salt: (.+)$/\1/')

    # Validate both password and decoded salt
    if [[ -z "$password" || -z "$salt" ]]; then
        echo "Error: Missing password or decoded salt for user $username." >&2
        exit 1
    fi

    echo "$password $salt"
}

# Function to generate a yescrypt hash using password and full salt
generate_password_hash() {
    local password="$1"
    local salt="$2"
    echo "$password" | mkpasswd -s -m yescrypt -S "$salt"
}

# Function to generate the /etc/shadow template
generate_shadow_template() {
    local root_hash="$1"
    local mfw78_hash="$2"
    cat <<EOF
root:!${root_hash}:19686::::::
bin:!*:19686::::::
daemon:!*:19686::::::
mail:!*:19686::::::
ftp:!*:19686::::::
http:!*:19686::::::
nobody:!*:19686::::::
dbus:!*:19686::::::
systemd-coredump:!*:19686::::::
systemd-network:!*:19686::::::
systemd-oom:!*:19686::::::
systemd-journal-remote:!*:19686::::::
systemd-journal-upload:!*:19686::::::
systemd-resolve:!*:19686::::::
systemd-timesync:!*:19686::::::
tss:!*:19686::::::
uuidd:!*:19686::::::
mfw78:${mfw78_hash}:19686:0:99999:7:::
git:!*:19686::::::
polkitd:!*:19686::::::
nvidia-persistenced:!*:19686::::::
avahi:!*:19686::::::
rtkit:!*:19686::::::
trezord:!*:19690::::::
deluge:!*:19699::::::
ntp:!*:19708::::::
_talkd:!*:19721::::::
tor:!*:19764::::::
rpc:!*:19808::::::
qemu:!*:19826::::::
libvirt-qemu:!*:19826::::::
dnsmasq:!*:19826::::::
alpm:!*:19991::::::
saned:!*:20018::::::
rpcuser:!*:20020::::::
EOF
}

# Main script logic

# Get password and full salt for root, then generate its hash
root_password_salt=$(get_password_and_salt "root")
root_password=$(echo "$root_password_salt" | awk '{print $1}')
root_full_salt=$(echo "$root_password_salt" | awk '{print $2}')
root_hash=$(generate_password_hash "$root_password" "$root_full_salt")

# Get password and full salt for mfw78, then generate its hash
mfw78_password_salt=$(get_password_and_salt "mfw78")
mfw78_password=$(echo "$mfw78_password_salt" | awk '{print $1}')
mfw78_full_salt=$(echo "$mfw78_password_salt" | awk '{print $2}')
mfw78_hash=$(generate_password_hash "$mfw78_password" "$mfw78_full_salt")

# Generate the shadow template
template_output=$(generate_shadow_template "$root_hash" "$mfw78_hash")

# Write the template to /etc/shadow
cat >> "$(CreateFile /etc/shadow)" <<EOF
$template_output
EOF

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