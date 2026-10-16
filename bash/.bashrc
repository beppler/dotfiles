# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# navigate through directories like zsh
shopt -s autocd

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias diff='diff --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -s ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -s ~/.bash_secrets ]; then
    . ~/.bash_secrets
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# bash history
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# append to the history file, don't overwrite it
shopt -s histappend

# reload history after each command
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# 24-bit color support
export COLORTERM=truecolor

# docker compose (https://github.com/docker/compose/issues/13472)
export COMPOSE_USER_ID=$(id -u)
export COMPOSE_GROUP_ID=$(id -g)
export COMPOSE_CLIENT_ARCH=$(uname -m)
export COMPOSE_CLIENT_OS=$(uname -s)

# keychain
if type -P keychain > /dev/null; then
    eval `keychain --eval --agents ssh --timeout 480`
fi

# mise (https://github.com/jdx/mise)
if type -P $HOME/.local/bin/mise > /dev/null; then
    eval "$($HOME/.local/bin/mise activate bash)"
    eval "$($HOME/.local/bin/mise complete bash)"
fi

# oh-my-posh
if type -P oh-my-posh > /dev/null; then
    eval "$(oh-my-posh init bash -c ~/.config/oh-my-posh/custom.omp.toml)"
fi

# kubectl
if type -P kubectl > /dev/null; then
    eval "$(kubectl completion bash)"
fi

# kubectl krew (https://krew.sigs.k8s.io/)
if [ -d "$HOME/.krew/bin" ]; then
    export PATH="$PATH:$HOME/.krew/bin"
fi

# github cli
if [ $(type -P gh) ]; then
    eval "$(gh completion -s bash)"
fi

# Google Cloud SDK
if [ -d "$HOME/.local/share/google-cloud-sdk" ]; then
    # The next line updates PATH for the Google Cloud SDK.
    if [ -f "$HOME/.local/share/google-cloud-sdk/path.bash.inc" ]; then . "$HOME/.local/share/google-cloud-sdk/path.bash.inc"; fi

    # The next line enables shell command completion for gcloud.
    if [ -f "$HOME/.local/share/google-cloud-sdk/completion.bash.inc" ]; then . "$HOME/.local/share/google-cloud-sdk/completion.bash.inc"; fi
fi
