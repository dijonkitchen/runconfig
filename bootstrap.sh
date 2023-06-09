#!/usr/bin/env bash

# For faster typing
alias ls='ls -la --color=auto'
alias g='git'

# In your `$HOME` directory,
# symbolic link these files:
cd "$HOME" || exit
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.gitconfig .
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.gitignore_global .
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.gitmessage .

cd -
