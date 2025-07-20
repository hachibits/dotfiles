# vim: set filetype=bash:
#export TERM=xterm-256color

if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

export CLICOLOR=1
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
alias ll="ls -al"

PS1='\[\e[1;33m\][\u@\h \W \t]\$\[\e[0m\] '
