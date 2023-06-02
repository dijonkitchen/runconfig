#!/usr/bin/env bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# In your `$HOME` directory,
# symbolic link these files:
cd "$HOME" || exit
ln -si ./.bashrc .

# Optionally link `.gitconfig`
# or use your own credentials.
ln -s ./.gitconfig .
ln -s ./.gitignore_global .
ln -s ./.gitmessage .

cd -
