#!/bin/bash

git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
ln -s $(pwd)/vimrc $HOME/.vimrc
vim +PluginInstall +qall!
