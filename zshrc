[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -z "$TMUX" ]; then
  tmux attach || exec tmux new-session && exit;
fi

[ -z "$TMPDIR" ] && TMPDIR=/tmp

export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden 2>/dev/null'
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'

if command -v nvim > /dev/null 2>&1; then
  alias vi='nvim'
fi

# Disable C-S and C-Q
if [[ -t 0 && $- = *i* ]]
then
  stty -ixoff -ixon
fi

set -o no_extended_glob

export EDITOR=vim
export PAGER=less

export PATH=~/go/bin:$PATH
export PATH=~/bin:$PATH
export PATH=~/.local/bin:$PATH

alias ls='ls -G'
alias l='ls -alF'
alias screen='screen -e\`n -s /bin/bash'
alias tmux="tmux -2"
alias tmuxls="ls $TMPDIR/tmux*/"
alias e='emacsclient -ca ""'
alias ecn='emacsclient -nc'
alias et='emacsclient -t'

source ~/.z.sh
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --reverse --inline-info +s --tac --query "$*" | sed 's/^[0-9,.]* *//')"
}

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
