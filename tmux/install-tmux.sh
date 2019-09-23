#!/bin/bash

ln -s $(pwd)/tmux.conf $HOME/.tmux.conf

# OSX-Specific
if [[ "$(uname)" = "Darwin" && "$(type -P brew)" != "" ]]
then
  brew install tmux reattach-to-user-namespace
  ln -s $(pwd)/tmux-osx.conf $HOME/.tmux-osx.conf
fi
