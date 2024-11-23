# Boot binaries
IgnorePath '/boot/*.img'
IgnorePath '/boot/**/*.EFI'
IgnorePath '/boot/**/*.efi'
IgnorePath '/boot/vmlin*'

# Certificate databases
IgnorePath '/etc/ca-certificates/extracted/*'
IgnorePath '/etc/ssl/certs/*'
IgnorePath '/etc/ssh/ssh_host_*'
IgnorePath '/etc/pacman.d/gnupg/*'

# LVM archives / metadata backups
IgnorePath '/etc/lvm/archive/*'
IgnorePath '/etc/lvm/backup/*'

# Don't keep iwd configuration
IgnorePath '/etc/iwd'

# Cache and generated files
IgnorePath '/etc/adjtime'
IgnorePath '/etc/iscsi/initiatorname.iscsi' # auto-generated file
IgnorePath '/etc/conf.d/lm_sensors' # auto-generated file
IgnorePath '/etc/*.cache'
IgnorePath '/etc/*.gen'
IgnorePath '/etc/os-release'
IgnorePath '/etc/machine-id'
IgnorePath '/etc/nvme'
IgnorePath '/etc/pacman.d/mirrorlist' # auto-generated file using reflector

# Auto-generated files for libvirt
ProcessLibvirtAutogeneratedFiles '/etc/libvirt'
IgnorePath '/etc/libvirt/**/autostart/*'

# Font configurations
IgnorePath '/etc/fonts/conf.d/*'

# Mount files
IgnorePath '*/.updated'
IgnorePath '/lost+found/*'
IgnorePath '**/lost+found'

IgnorePath '/code'  # Local code repositories
IgnorePath '/data'  # Local data repositories
IgnorePath '/srv'   # Local service repositories

# Var databases, logs, swap and temp files
IgnorePath '/var/lib/*'
IgnorePath '/var/log/*'
IgnorePath '/var/tmp/*'
IgnorePath '/var/db/sudo'

IgnorePath '/usr/**/*.cache'
IgnorePath '/usr/lib/locale'
IgnorePath '/usr/lib/modules'
IgnorePath '/usr/lib/udev'
IgnorePath '/usr/share/glib-2.0/schemas/gschemas.compiled'
IgnorePath '/usr/share/info/dir'
IgnorePath '/usr/share/mime'

