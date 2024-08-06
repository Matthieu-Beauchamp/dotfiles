" From the docs, loads ~/.vimrc
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.config/vim-configs/myNvim/.vimrc
