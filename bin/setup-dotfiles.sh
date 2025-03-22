#!/bin/bash

# Get the user's home directory
HOME_DIR="$HOME"

# Get the directory where the script resides
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname $SCRIPT_DIR)"

# Validate input argument
if [[ "$1" != "macos" && "$1" != "linux" ]]; then
    echo "Usage: $0 [macos|linux]"
    exit 1
fi

# Set the platform-specific dotfiles directory
PLATFORM_DIR="$REPO_DIR/$1"

if [[ ! -d "$PLATFORM_DIR" ]]; then
    echo "Error: Directory $PLATFORM_DIR does not exist."
    exit 1
fi

# Exclusions
EXCLUSIONS=(".git" "README.md" "bin" "$(basename "$0")") # Includes the script name

# Function to check if a file or directory should be excluded
is_excluded() {
    local file="$1"
    for exclude in "${EXCLUSIONS[@]}"; do
        if [[ "$file" == "$exclude" ]]; then
            return 0 # True, it is excluded
        fi
    done
    return 1 # False, it is not excluded
}

# Link hidden files and directories from the platform-specific directory
for file in "$PLATFORM_DIR"/.*; do
    # Skip . and ..
    [[ "$file" == "$PLATFORM_DIR/." || "$file" == "$PLATFORM_DIR/.." ]] && continue

    # Get the base name of the file
    base_name=$(basename "$file")

    # Check if the file is excluded
    if is_excluded "$base_name"; then
        echo "Skipping $base_name"
        continue
    fi

    # Handle .config directory separately
    if [[ "$base_name" == ".config" && -d "$file" ]]; then
        echo "Processing .config directory..."
        mkdir -p "$HOME_DIR/.config"
        for config_dir in "$file"/*; do
            config_base_name=$(basename "$config_dir")
            ln -sf "$config_dir" "$HOME_DIR/.config/$config_base_name"
            echo "Linked $config_dir to $HOME_DIR/.config/$config_base_name"
        done
    else
        # Create a symlink for other files or directories
        ln -sf "$file" "$HOME_DIR/$base_name"
        echo "Linked $file to $HOME_DIR/$base_name"
    fi

done

echo "Dotfiles setup complete for $1!"
