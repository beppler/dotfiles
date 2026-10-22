# Initialization
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt autocd
autoload -U compinit; compinit

# aliases
alias ls="ls -G"
alias ll="ls -la"

alias hcurl='curl -s -D - -o /dev/null'
alias lg="lazygit"

# mise (https://github.com/jdx/mise)
if (( $+commands[mise] )); then
    eval "$(mise activate zsh)"
    eval "$(mise complete zsh)"
fi

# oh-my-posh
if (( $+commands[oh-my-posh] )); then
    eval "$(oh-my-posh init zsh -c ~/.config/oh-my-posh/custom.omp.toml)"
fi
