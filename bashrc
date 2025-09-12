# vim: set filetype=bash:
#export TERM=xterm-256color

export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc

BASE=$(dirname $(readlink $BASH_SOURCE))

if [ -z "$TMUX" ]; then
  tmux attach || exec tmux new-session && exit;
fi

# Disable C-S and C-Q
if [[ -t 0 && $- = *i* ]]
then
  stty -ixoff -ixon
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden 2>/dev/null'

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

export PATH=~/go/bin:$PATH
if [ "$PLATFORM" = 'Darwin' ]; then
  export PATH=~/.local/bin:$PATH
  export PATH=/opt/homebrew/opt/llvm/bin:$PATH
  export CC=/opt/homebrew/opt/llvm/bin/clang
  export CXX=$CC++
  export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/llvm/lib"
  export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/llvm/include"
else
  export PATH=~/bin
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/local/lib
fi
export EDITOR=vim
export PAGER=less

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
elif [ "$PLATFORM" = Darwin ]; then
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
alias c='g++ -Wall -Wconversion -Wfatal-errors -g -std=c++17'

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
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --reverse --inline-info +s --tac --query "$*" | sed 's/^[0-9,.]* *//')"
}

co() {
  g++ -std=c++17 -Wall -Wextra -g -Wshadow -Wformat=2 -Wfloat-equal -Wconversion -Wlogical-op -Wcast-qual -Wcast-align -D_GLIBCXX_DEBUG -D_FORTIFY_SOURCE=2 -DLOCAL -o $1.o $1.cpp
}

run() {
  co $1 && ./$1.o;
}

