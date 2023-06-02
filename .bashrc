# Linuxbrew
HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:~/bin:$PATH"

# For faster typing
alias ls='ls -FlaG'
alias g='git'

# Javascript
export NVM_DIR="$HOME/.nvm"

# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# This loads nvm shell completions
# shellcheck source=/dev/null
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# place this after nvm initialization!
if [ -n "${BASH_VERSION}" ]; then
  cdnvm() {
      command cd "$@" || return $?
      nvm_path=$(nvm_find_up .nvmrc | tr -d '\n')

      # If there are no .nvmrc file, use the default nvm version
      if [[ ! $nvm_path = *[^[:space:]]* ]]; then

          declare default_version;
          default_version=$(nvm version default);

          # If there is no default version, set it to `node`
          # This will use the latest version on your machine
          if [[ $default_version == "N/A" ]]; then
              nvm alias default node;
              default_version=$(nvm version default);
          fi

          # If the current version is not the default version, set it to use the default version
          if [[ $(nvm current) != "$default_version" ]]; then
              nvm use default;
          fi

      elif [[ -s $nvm_path/.nvmrc && -r $nvm_path/.nvmrc ]]; then
          declare nvm_version
          nvm_version=$(<"$nvm_path"/.nvmrc)

          declare locally_resolved_nvm_version
          # `nvm ls` will check all locally-available versions
          # If there are multiple matching versions, take the latest one
          # Remove the `->` and `*` characters and spaces
          # `locally_resolved_nvm_version` will be `N/A` if no local versions are found
          locally_resolved_nvm_version=$(nvm ls --no-colors "$nvm_version" | tail -1 | tr -d '\->*' | tr -d '[:space:]')

          # If it is not already installed, install it
          # `nvm install` will implicitly use the newly-installed version
          if [[ "$locally_resolved_nvm_version" == "N/A" ]]; then
              nvm install "$nvm_version";
          elif [[ $(nvm current) != "$locally_resolved_nvm_version" ]]; then
              nvm use "$nvm_version";
          fi
      fi
  }

  alias cd='cdnvm'
  cdnvm "$PWD" || exit
  
# Python
if command -v pyenv 1>/dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi
