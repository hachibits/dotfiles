[ -f "$LOCAL_ADMIN_SCRIPTS/master.zshrc" ] && source "$LOCAL_ADMIN_SCRIPTS/master.zshrc"
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

alias rm='rm -i'
alias ls='ls -G'
alias mv='mv -i'
alias vim='vim -X -O'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Ignore command dupes in history
setopt HIST_IGNORE_DUPS

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
