#!/bin/bash

# Get the user's home directory
HOME_DIR="$HOME"

# Get the directory where the script resides
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Exclusions
EXCLUSIONS=(".git" "README.md" "$(basename "$0")") # Includes the script name

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

# Link hidden files and directories from the dotfiles directory
for file in "$DOTFILES_DIR"/.*; do
    # Skip . and ..
    [[ "$file" == "$DOTFILES_DIR/." || "$file" == "$DOTFILES_DIR/.." ]] && continue

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

echo "Dotfiles setup complete!"

