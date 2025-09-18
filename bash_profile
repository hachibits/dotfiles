if [ -f /etc/profile ]; then
  PATH=
  source /etc/profile
fi

. ~/.bashrc

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH=~/bin:$PATH
export PATH=~/.local/bin:$PATH

export PATH=/opt/homebrew/opt/llvm/bin:$PATH
export CC=/opt/homebrew/opt/llvm/bin/clang
export CXX=$CC++
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/llvm/include"

export GPG_TTY=$(tty)
