# CLI Apps
AddPackage --foreign aconfmgr-git # A configuration manager for Arch Linux
AddPackage cdrtools # Highly portable CD/DVD/BluRay command line recording software
AddPackage chezmoi # Manage your dotfiles across multiple machines
AddPackage --foreign gurk-bin # CLI client for Signal
AddPackage iotop # View I/O usage of processes
AddPackage magic-wormhole # Securely transfer data between computers
AddPackage neovim # Fork of Vim aiming to improve user experience, plugins, and GUIs
AddPackage pass # Stores, retrieves, generates, and synchronizes passwords securely
AddPackage --foreign spotify-tui # Spotify client for the terminal written in Rust
AddPackage spotifyd # Lightweight spotify streaming daemon with spotify connect support
AddPackage tor # Anonymizing overlay network.

# Taskwarrior
AddPackage --foreign taskchampion-sync-server # The server Taskwarrior syncs to
AddPackage taskwarrior-tui # A terminal user interface for taskwarrior
AddPackage timew # Timewarrior, A command line time tracking application
CreateLink /etc/systemd/system/multi-user.target.wants/taskchampion-sync-server.service /usr/lib/systemd/system/taskchampion-sync-server.service
CreateLink /etc/systemd/system/multi-user.target.wants/trezord.service /usr/lib/systemd/system/trezord.service
CreateLink /etc/udev/rules.d/51-trezor.rules /usr/lib/udev/rules.d/51-trezor.rules

AddPackage yubikey-manager # Python library and command line tool for configuring a YubiKey
AddPackage yubikey-personalization # Yubico YubiKey Personalization library and tool
CreateLink /etc/systemd/system/sockets.target.wants/pcscd.socket /usr/lib/systemd/system/pcscd.socket
