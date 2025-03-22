#!/bin/bash
set -e

# Determine the repository root by going up one directory from where this script is located.
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Change directory to the repository root.
cd "$REPO_ROOT" || { echo "Failed to change directory to $REPO_ROOT"; exit 1; }

# Pull the latest changes from the remote repository.
git pull

echo "Pulled latest changes from the remote repository."

