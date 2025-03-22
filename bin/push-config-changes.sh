#!/bin/bash
set -e

# Determine the repository root by going up one directory from where this script is located.
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Change directory to the repository root.
cd "$REPO_ROOT" || { echo "Failed to change directory to $REPO_ROOT"; exit 1; }

# Stage all changes.
git add --all

# Check if there are changes to commit.
if git diff-index --quiet HEAD --; then
    echo "No changes detected. Nothing to commit."
else
    # Create a commit message with the current date and time.
    commit_msg="Update dotfiles: $(date +'%Y-%m-%d %H:%M:%S')"
    
    # Commit the changes.
    git commit -m "$commit_msg"
    echo "Committed changes with message: '$commit_msg'"
    
    # Push the changes to the current branch.
    git push
    echo "Pushed changes to the remote repository."
fi


