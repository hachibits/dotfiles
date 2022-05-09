[ -f "$LOCAL_ADMIN_SCRIPTS/master.zshrc" ] && source "$LOCAL_ADMIN_SCRIPTS/master.zshrc"
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

alias rm='rm -i'
alias ls='ls -G'
alias mv='mv -i'
alias vim='vim -X -O'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Disable C-S and C-Q
if [[ -t 0 && $- = *i* ]]
then
    stty -ixon
fi 

# Disable globbing
set -o no_extended_glob

# Don't save duplicate commands in history
setopt HIST_IGNORE_DUPS

# bash completion
if [ -f $HOME/.zsh/bash_completion ]; then
#   . $HOME/.zsh/bash_completion
fi

zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# Git completion
fpath+=$HOME/.zsh/_git

# Command line vi mode
set -o vi

# zsh prompt formatting
fpath+=$HOME/.zsh/pure

# zsh git autocomplete
autoload -Uz compinit && compinit

autoload -U promptinit; promptinit
prompt pure

# Homebrew
eval $(/opt/homebrew/bin/brew shellenv)

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
