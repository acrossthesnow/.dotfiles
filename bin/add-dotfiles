#!/bin/bash

# Get the user's home directory
HOME_DIR="$HOME"

# Get the directory where the script resides
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname $SCRIPT_DIR)"

# Validate input arguments
if [[ "$1" != "macos" && "$1" != "linux" ]]; then
    echo "Usage: $0 [macos|linux] <source-path> [additional-paths...]"
    exit 1
fi

PLATFORM="$1"
shift
SOURCE_PATHS=("$@")

if [[ ${#SOURCE_PATHS[@]} -eq 0 ]]; then
    echo "Error: You must provide at least one source path."
    exit 1
fi

# Set the platform-specific dotfiles directory
PLATFORM_DIR="$REPO_DIR/$PLATFORM"

if [[ ! -d "$PLATFORM_DIR" ]]; then
    mkdir -p "$PLATFORM_DIR"
    echo "Created missing platform directory: $PLATFORM_DIR"
fi

for SOURCE_PATH in "${SOURCE_PATHS[@]}"; do
    if [[ ! -e "$SOURCE_PATH" ]]; then
        echo "Error: $SOURCE_PATH does not exist. Skipping."
        continue
    fi

    # Determine the destination path in the repo
    if [[ "$SOURCE_PATH" == "$HOME_DIR/.config"* ]]; then
        DEST_DIR="$PLATFORM_DIR/.config"
        RELATIVE_PATH="${SOURCE_PATH#$HOME_DIR/.config/}"
        DEST_PATH="$DEST_DIR/$RELATIVE_PATH"
    else
        DEST_DIR="$PLATFORM_DIR"
        RELATIVE_PATH="${SOURCE_PATH#$HOME_DIR/}"
        DEST_PATH="$DEST_DIR/$RELATIVE_PATH"
    fi

    # Create the destination directory if it doesn't exist
    mkdir -p "$(dirname "$DEST_PATH")"

    # Move the file or directory to the platform-specific folder
    cp -R "$SOURCE_PATH" "$DEST_PATH"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to copy $SOURCE_PATH to $DEST_PATH"
        continue
    fi

    # Remove the old file or directory
    rm -rf "$SOURCE_PATH"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to remove $SOURCE_PATH"
        continue
    fi

    # Link the new file or directory to the original location
    ln -sf "$DEST_PATH" "$SOURCE_PATH"
    if [[ $? -eq 0 ]]; then
        echo "Successfully added $SOURCE_PATH to $PLATFORM_DIR and linked it back."
    else
        echo "Error: Failed to create symlink from $DEST_PATH to $SOURCE_PATH"
    fi

done

