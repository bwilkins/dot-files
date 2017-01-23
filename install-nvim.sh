#!/bin/bash

mkdir -p ~/.config/nvim/dein/repos/github.com/Shougo/dein.vim
git clone https://github.com/Shougo/dein.vim.git $HOME/.config/nvim/dein/github.com/Shougo/dein.vim
ln -s $(pwd)/init.vim $HOME/.config/nvim/init.vim
