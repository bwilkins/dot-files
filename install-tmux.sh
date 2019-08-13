#!/bin/bash

ln -s $(pwd)/tmux.conf $HOME/.tmux.conf

# OSX-Specific
if [ "$(uname)" = "Darwin" ]
then
  brew install reattach-to-user-namespace
  ln -s $(pwd)/tmux-osx.conf $HOME/.tmux-osx.conf
fi
