#!/usr/bin/env bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# In your `$HOME` directory,
# symbolic link these files:
cd "$HOME" || exit
ln -s /workspaces/.codespaces/.persistedshare/dotfiles/.bashrc .
ln -s /workspaces/.codespaces/.persistedshare/dotfiles/.gitconfig .
ln -s /workspaces/.codespaces/.persistedshare/dotfiles/.gitignore_global .
ln -s /workspaces/.codespaces/.persistedshare/dotfiles/.gitmessage .

cd -
