#!/bin/bash

mkdir -p ~/.vim/bundle
mkdir -p ~/.config/nvim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.config/nvim/bundle/Vundle.vim
ln -s $(pwd)/vimrc $HOME/.vimrc
ln -s $(pwd)/vimrc $HOME/.config/nvim/init.vim
vim +PluginInstall +qall!
