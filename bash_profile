if [ -f /etc/profile ]; then
  PATH=
  source /etc/profile
fi

. ~/.bashrc

eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH=~/.local/bin:$PATH
export PATH=/opt/homebrew/opt/llvm/bin:$PATH
export CC=/opt/homebrew/opt/llvm/bin/clang
export CXX=$CC++
export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/llvm/include"

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

export GPG_TTY=$(tty)
