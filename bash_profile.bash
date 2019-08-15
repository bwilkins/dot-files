#!/usr/bin/env bash

export EDITOR=vim
# Path to the bash it configuration
export BASH_IT="${HOME}/.bash_it"

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='powerline'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to the command you use for todo.txt-cli
export TODO="t"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

if [ -a "${HOME}/.bash_env" ]; then
  source "${HOME}/.bash_env"
fi


# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

if [ -a "${HOME}/.bash_aliases" ]; then
  source "${HOME}/.bash_aliases"
fi

# Load Bash It
source $BASH_IT/bash_it.sh

# mkdir -p $HOME/.config/term
# infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $HOME/.config/term/$TERM.ti
# tic $HOME/.config/term/$TERM.ti

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Replace cd with pushd https://gist.github.com/mbadran/130469
function push_cd() {
  # typing just `push_cd` will take you $HOME ;)
  if [ -z "$1" ]; then
    push_cd "$HOME"

  # use `push_cd -` to visit previous directory
  elif [ "$1" == "-" ]; then
    if [ "$(dirs -p | wc -l)" -gt 1 ]; then
      current_dir="$PWD"
      popd > /dev/null
      pushd -n $current_dir > /dev/null
    elif [ -n "$OLDPWD" ]; then
      push_cd $OLDPWD
    fi

  # use `push_cd -l` or `push_cd -s` to print current stack of folders
  elif [ "$1" == "-l" ] || [ "$1" == "-s" ]; then
    dirs -v

  # use `push_cd -l N` to go to the Nth directory in history (pushing)
  elif [ "$1" == "-g" ] && [[ "$2" =~ ^[0-9]+$ ]]; then
    indexed_path=$(dirs -p | sed -n $(($2+1))p)
    push_cd $indexed_path

  # use `push_cd +N` to go to the Nth directory in history (pushing)
  elif [[ "$1" =~ ^+[0-9]+$ ]]; then
    push_cd -g ${1/+/}

  # use `push_cd -N` to go n directories back in history
  elif [[ "$1" =~ ^-[0-9]+$ ]]; then
    for i in `seq 1 ${1/-/}`; do
      popd > /dev/null
    done

  # use `push_cd -- <path>` if your path begins with a dash
  elif [ "$1" == "--" ]; then
    shift
    pushd -- "$@" > /dev/null

    # basic case: move to a dir and add it to history
  else
    pushd "$@" > /dev/null

    if [ "$1" == "." ] || [ "$1" == "$PWD" ]; then
      popd -n > /dev/null
    fi
  fi

  if [ -n "$CD_SHOW_STACK" ]; then
    dirs -v
  fi
}

# replace standard `cd` with enhanced version, ensure tab-completion works
alias cd=push_cd
complete -d cd
