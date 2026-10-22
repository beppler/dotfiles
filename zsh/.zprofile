# Local executables
export PATH="$HOME/.local/bin:$PATH"

# ssh
if [[ "$OSTYPE" == "darwin"* ]]; then
    ssh-add --apple-load-keychain -q
fi

# brew
if (( $+commands[brew] )); then
    export HOMEBREW_NO_ENV_HINTS=1
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

# go installed binaries
if [ -d "$HOME/go/bin" ]; then
    path+=("$HOME/go/bin")
fi
