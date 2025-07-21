# vim: set filetype=bash:
#export TERM=xterm-256color

if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

#if [ -z "$TMUX" ]; then
#  tmux attach || exec tmux new-session && exit;
#fi

BASE=$(dirname $(readlink $BASH_SOURCE))

# Disable C-S and C-Q
if [[ -t 0 && $- = *i* ]]
then
  stty -ixoff -ixon
fi

export EDITOR=vim
export PAGER=less

export PATH=~/go/bin:$PATH
export PATH=~/.local/bin:$PATH

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden 2>/dev/null'

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

set -o vi

shopt -s histappend
shopt -s checkwinsize

# man bash
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
[ -z "$TMPDIR" ] && TMPDIR=/tmp

export COPYFILE_DISABLE=true

export BASH_SILENCE_DEPRECATION_WARNING=1

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
elif [ $(uname -s) = Darwin ]; then
  alias ls='ls -G'
fi

if command -v nvim > /dev/null 2>&1; then
  alias vi=nvim
  export EDITOR=nvim
fi

alias l='ls -alF'
alias ll='ls -l'
alias screen='screen -e\`n -s /bin/bash'
alias grep='grep --color=auto'
alias rgrep='grep -r -n --color=auto'
#alias tmux='export TERM=screen-256color; /usr/local/bin/tmux'
alias tmux="tmux -2"
alias tmuxls="ls $TMPDIR/tmux*/"

__git_ps1() { :;}
if [ -e ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
fi
PROMPT_COMMAND='history -a; printf "\[\e[38;5;59m\]%$(($COLUMNS - 4))s\r" "$(__git_ps1)"'
PS1='\[\e[38;5;220m\][\u@\h \w]\$\[\e[0m\] '

if [ -n "$TMUX_PANE" ]; then
  ftpane() {
    local panes current_window current_pane target target_window target_pane
    panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
    current_pane=$(tmux display-message -p '#I:#P')
    current_window=$(tmux display-message -p '#I')

    target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

    target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
    target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

    if [[ $current_window -eq $target_window ]]; then
      tmux select-pane -t ${target_window}.${target_pane}
    else
      tmux select-pane -t ${target_window}.${target_pane} &&
      tmux select-window -t $target_window
    fi
  }
fi

# Z integration
source $BASE/z.sh
unalias z 2> /dev/null
z() {
  if [[ -z "$*" ]]; then
    cd "$(_z -l 2>&1 | tac | fzf | sed 's/^[0-9]* *//')"
  else
    _z "$@"
  fi
}
