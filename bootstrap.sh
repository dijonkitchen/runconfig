#!/usr/bin/env bash

# For faster typing
## Need to append to Codespaces defaults to get their benefits

## bash
echo 'alias ls="ls -la --color=auto"' >> ~/.bashrc
echo 'alias g="git"' >> ~/.bashrc

echo 'alias be="bundle exec"' >> ~/.bashrc

## zsh
echo 'alias ls="ls -la --color=auto"' >> ~/.zshrc
echo 'alias g="git"' >> ~/.zshrc

echo 'alias be="bundle exec"' >> ~/.zshrc

# In your `$HOME` directory,
# symbolic link these files:
cd "$HOME" || exit
ln -sf /workspaces/.codespaces/.persistedshare/dotfiles/.gitconfig .

cd -
