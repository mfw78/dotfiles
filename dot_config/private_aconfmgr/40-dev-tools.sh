# Development tools
AddPackage base-devel # Basic tools to build Arch Linux packages
AddPackage --foreign devpod-cli-bin # Codespaces but open-source, client-only, and unopinionated - unofficial package
AddPackage devtools # Tools for Arch Linux package maintainers
AddPackage dnsmasq # Lightweight, easy to configure DNS forwarder and DHCP server
AddPackage docker # Pack, ship and run any application as a lightweight container
AddPackage docker-buildx # Docker CLI plugin for extended build capabilities with BuildKit
AddPackage docker-compose # Fast, isolated development environments using Docker
AddPackage git-filter-repo # Quickly rewrite git repository history (filter-branch replacement)
AddPackage libvirt # API for controlling virtualization engines (openvz,kvm,qemu,virtualbox,xen,etc)
AddPackage patch # A utility to apply patch files to original sources
AddPackage protobuf # Protocol Buffers - Google's data interchange format
AddPackage python-pip # The PyPA recommended tool for installing Python packages
AddPackage python-virtualenv # Virtual Python Environment builder
AddPackage qemu-desktop # A QEMU setup for desktop environments
AddPackage sqlitebrowser # SQLite Database browser is a light GUI editor for SQLite databases, built on top of Qt
AddPackage swtpm # Libtpms-based TPM emulator with socket, character device, and Linux CUSE interface
AddPackage virt-manager # Desktop user interface for managing virtual machines
AddPackage --foreign visual-studio-code-bin # Visual Studio Code (vscode): Editor for building and debugging modern web and cloud applications (official binary version)

# Languages
AddPackage go # Core compiler tools for the Go programming Language
AddPackage nodejs # Evented I/O for V8 javascript
AddPackage npm # JavaScript package manager

# Set libvirt to use iptables as the firewall backend
f="$(GetPackageOriginalFile libvirt /etc/libvirt/network.conf)"
sed -i 's/^#*\s*firewall_backend = ".*"/firewall_backend = "iptables"/' "$f"

# Enable libvirt services
CreateLink /etc/systemd/system/sockets.target.wants/libvirtd-admin.socket /usr/lib/systemd/system/libvirtd-admin.socket
CreateLink /etc/systemd/system/sockets.target.wants/libvirtd-ro.socket /usr/lib/systemd/system/libvirtd-ro.socket
CreateLink /etc/systemd/system/sockets.target.wants/libvirtd.socket /usr/lib/systemd/system/libvirtd.socket

# Enable docker socket (lazy-load docker)
CreateLink /etc/systemd/system/sockets.target.wants/docker.socket /usr/lib/systemd/system/docker.socket
