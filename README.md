Dotfiles Setup Script
This repository contains a setup script for managing your dotfiles. The script symlinks configuration files and directories from the repository to your home directory, ensuring a consistent development environment.
Features

    Symlinks all hidden files and directories (.*) from the dotfiles directory to the user's home directory.

    Handles the .config directory separately by linking all subdirectories inside .config into ~/.config.

    Automatically skips:

        The .git directory

        The README.md file

        The setup script itself

Usage

    Clone the Repository

    Clone the repository into a directory (e.g., ~/dotfiles):
    git clone <repository_url> ~/dotfiles

    Navigate to the Dotfiles Directory
    cd ~/dotfiles

    Make the Setup Script Executable
    chmod +x setup_dotfiles.sh

    Run the Setup Script

    Execute the script to set up symlinks:
    ./setup_dotfiles.sh

What the Script Does

    Links Hidden Files: Symlinks all hidden files and directories (e.g., .zshrc, .vimrc) into your home directory.

    Manages .config Separately: Creates symlinks for each subdirectory inside .config to ~/.config.

    Handles Exclusions: Skips the .git folder, README.md, and the setup script itself.

Directory Structure

Here’s an example of how your dotfiles repository might look:
~/dotfiles
├── .zshrc
├── .vimrc
├── .config
│   ├── nvim
│   ├── alacritty
│   └── other-config
├── README.md
├── .git
└── setup_dotfiles.sh

After running the script:

    ~/.zshrc → ~/dotfiles/.zshrc

    ~/.vimrc → ~/dotfiles/.vimrc

    ~/.config/nvim → ~/dotfiles/.config/nvim

    ~/.config/alacritty → ~/dotfiles/.config/alacritty

Customization

To modify exclusions or add specific behavior, edit the EXCLUSIONS array or logic in setup_dotfiles.sh:
EXCLUSIONS=(".git" "README.md" "$(basename "$0")")
Notes

    The script uses ln -sf to create symlinks, overwriting existing files if necessary. Be cautious if you have conflicting configurations.

    Ensure the dotfiles directory is well-organized to avoid unwanted overwrites.
