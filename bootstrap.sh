#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "detected mac os"
else
  echo "detected nothing assuming linux"
fi


if [[ "$ZSH_NAME" == "zsh" ]]; then
  echo "detected zsh"
else
  echo "detected nothing, assuming bash"
fi

git pull origin master;

function do_bootstrap() {
  rsync --exclude ".git/" \
    --exclude "README.md" \
    -avh --no-perms $DIR/home ~;
}

do_bootstrap;
unset do_bootstrap;

