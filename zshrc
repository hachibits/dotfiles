[ -f "$LOCAL_ADMIN_SCRIPTS/master.zshrc" ] && source "$LOCAL_ADMIN_SCRIPTS/master.zshrc"
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Ignore command dupes in history
setopt HIST_IGNORE_DUPS

set -o vi
