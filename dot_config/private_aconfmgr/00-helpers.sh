# Function to find and process libvirt auto-generated files (and ignore them)
ProcessLibvirtAutogeneratedFiles() {
    local directory="$1"

    # Ensure the directory exists
    if [[ ! -d "$directory" ]]; then
        echo "Error: Directory '$directory' does not exist."
        return 1
    fi

    # Find files and check for the auto-generated warning using sudo
    sudo find "$directory" -type f | while read -r file; do
        if sudo grep -q "WARNING: THIS IS AN AUTO-GENERATED FILE" "$file"; then
            IgnorePath "$file"
        fi
    done
}
