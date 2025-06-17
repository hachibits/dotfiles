BASE=$(pwd)

mkdir -p ~/.config/nvim
touch ~/.config/nvim/init.vim
ln -sf $BASE/init.vim ~/.config/nvim/init.vim
vim -es -u ~/.vimrc +PlugInstall +qa
nvim -es -u ~/.config/nvim/init.vim +PlugInstall +qa
