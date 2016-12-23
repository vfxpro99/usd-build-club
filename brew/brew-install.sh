#!/bin/bash

ROOT_DIR=$(pwd)
SCRIPT_DIR=`dirname "$0"`
# Make SCRIPT_DIR absolute
cd $SCRIPT_DIR >> /dev/null && SCRIPT_DIR=`pwd` && cd - >> /dev/null

HOMEBREW="$ROOT_DIR/homebrew"
BREW="$HOMEBREW/bin/brew"

# ensure only run in darwin env
OS_TYPE=$(uname)
if [ ${OS_TYPE} == "Darwin" ]; then
  if [ ! -e "$BREW" ]; then
    mkdir -p $HOMEBREW
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOMEBREW
  fi

  # update
  $BREW update

  # system deps
  $BREW install gflags
fi

