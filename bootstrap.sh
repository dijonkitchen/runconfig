#!/usr/bin/env bash

bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# In your `$HOME` directory,
# symbolic link these files:
cd "$HOME" || exit
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.bashrc .
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.gitconfig .
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.gitignore_global .
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.gitmessage .

cd -
