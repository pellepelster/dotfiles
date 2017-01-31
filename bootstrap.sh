#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OS="none"
echo -n "detecting os..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "mac os"
  OS="mac"
else
  echo "assuming linux"
  OS="linux"
fi

SHELL="none"
echo -n "detecting shell..."
if [ -z ${ZSH+x} ]; then 
  echo "assuming bash"
  SHELL="BASH"
else
  echo "zsh"
  SHELL="bash"
fi

echo -n "updating repository..."
git pull origin master
echo "done";

function do_bootstrap() {
  rsync --exclude ".git/" \
    --exclude "README.md" \
    -avh --no-perms $DIR/home ~;
}

OS_PRERUN_SCRIPT="${DIR}/${OS}/pre_run.sh"

if [ -e ${OS_PRERUN_SCRIPT} ]; then
  echo -n "running os pre-run script ${OS_PRERUN_SCRIPT}..."
  echo "done"
else
  echo "no os pre-run script found ${OS_PRERUN_SCRIPT}"
fi

do_bootstrap;
unset do_bootstrap;

