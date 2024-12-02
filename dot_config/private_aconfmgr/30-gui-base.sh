# GUI environment
AddPackage brightnessctl # Lightweight brightness control tool
AddPackage grim # Screenshot utility for Wayland
AddPackage hyprland # A dynamic tiling Wayland compositor based on wlroots that doesn't sacrifice on its looks.
AddPackage hyprpaper # A blazing fast wayland wallpaper utility with IPC controls
AddPackage hyprlock # hyprland's GPU-accelerated screen locking utility
AddPackage hypridle # hyprland's idle daemon
AddPackage libva-nvidia-driver # VA-API implementation that uses NVDEC as a backend
AddPackage libva-utils # Intel VA-API Media Applications and Scripts for libva
AddPackage nvidia # NVIDIA kernel modules
AddPackage slurp # Select a region in a Wayland compositor
AddPackage swayidle # Idle management daemon for Wayland
AddPackage swaylock # Screen locker for Wayland
AddPackage swaync # A simple GTK based notification daemon for Sway
AddPackage --foreign ttf-meslo-nerd-font-powerlevel10k # Meslo Nerd Font patched for Powerlevel10k
AddPackage waybar # Highly customizable Wayland bar for Sway and Wlroots based compositors
AddPackage wf-recorder # Screen recorder for wlroots-based compositors such as sway
AddPackage wireplumber # Session / policy manager implementation for PipeWire
AddPackage wl-clipboard # Command-line copy/paste utilities for Wayland
AddPackage wofi # Launcher for wlroots-based wayland compositors
AddPackage --foreign wofi-emoji # Emoji picker for Wayland using wofi and wtype
AddPackage --foreign wofi-pass # A Wayland-native interface for conveniently using pass
AddPackage xdg-desktop-portal-hyprland # xdg-desktop-portal backend for hyprland
AddPackage xdg-desktop-portal # Desktop integration portals for sandboxed apps
AddPackage xdg-user-dirs # Manage user directories like ~/Desktop and ~/Music

# Fonts
AddPackage noto-fonts-cjk # Google Noto CJK fonts
AddPackage noto-fonts-emoji # Google Noto emoji fonts
AddPackage noto-fonts-extra # Google Noto TTF fonts - additional variants
AddPackage ttf-ibmplex-mono-nerd # Patched font IBM Plex Mono (Blex) from nerd fonts library
AddPackage ttf-jetbrains-mono-nerd # Patched font JetBrains Mono from nerd fonts library
AddPackage ttf-meslo-nerd # Patched font Meslo LG from nerd fonts library
AddPackage ttf-opensans # Sans-serif typeface commissioned by Google

# Audio
AddPackage pulseaudio-alsa # ALSA Configuration for PulseAudio
AddPackage pulseaudio-bluetooth # Bluetooth support for PulseAudio

# Add nvidia module configuration to modprobe.d
cat >> "$(CreateFile /etc/modprobe.d/nvidia.conf)" <<EOF
options nvidia_drm modeset=1 fbdev=1
EOF

# Enable bluetooth service
CreateLink /etc/systemd/system/bluetooth.target.wants/bluetooth.service /usr/lib/systemd/system/bluetooth.service
CreateLink /etc/systemd/system/dbus-org.bluez.service /usr/lib/systemd/system/bluetooth.service

# NVIDIA services
CreateLink /etc/systemd/system/systemd-hibernate.service.wants/nvidia-hibernate.service /usr/lib/systemd/system/nvidia-hibernate.service
CreateLink /etc/systemd/system/systemd-hibernate.service.wants/nvidia-resume.service /usr/lib/systemd/system/nvidia-resume.service
CreateLink /etc/systemd/system/systemd-suspend.service.wants/nvidia-resume.service /usr/lib/systemd/system/nvidia-resume.service
CreateLink /etc/systemd/system/systemd-suspend.service.wants/nvidia-suspend.service /usr/lib/systemd/system/nvidia-suspend.service

CreateLink /etc/systemd/user/default.target.wants/xdg-user-dirs-update.service /usr/lib/systemd/user/xdg-user-dirs-update.service

# Enable WirePlumber
CreateLink /etc/systemd/user/pipewire-session-manager.service /usr/lib/systemd/user/wireplumber.service
CreateLink /etc/systemd/user/pipewire.service.wants/wireplumber.service /usr/lib/systemd/user/wireplumber.service

# PipeWire
CreateLink /etc/systemd/user/sockets.target.wants/pipewire.socket /usr/lib/systemd/user/pipewire.socket
CreateLink /etc/systemd/user/sockets.target.wants/pulseaudio.socket /usr/lib/systemd/user/pulseaudio.socket

# GNOME Keyring
CreateLink /etc/systemd/user/sockets.target.wants/gnome-keyring-daemon.socket /usr/lib/systemd/user/gnome-keyring-daemon.socket
CreateLink /etc/systemd/user/sockets.target.wants/p11-kit-server.socket /usr/lib/systemd/user/p11-kit-server.socket

