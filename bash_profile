if [ -f /etc/profile ]; then
  PATH=
  source /etc/profile
fi

. ~/.bashrc

export GPG_TTY=$(tty)
