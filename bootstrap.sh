#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="${DIR}/backup"
TIMESTAMP=$(date +%Y%m%d%H%M)

mkdir ${BACKUP_DIR} || true

OS="none"
echo -n "detecting os..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "mac os"
  OS="macos"
else
  echo "assuming linux"
  OS="linux"
  if [ -f "/etc/lsb-release" ]; then
    source /etc/lsb-release
    echo ${DISTRIBUTION_ID}
  fi
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

if [[ $(git ls-files -m | wc -l) -eq 0 ]]; then 
  echo -n "updating repository..."
  git pull origin master && echo "done";
else 
  echo "repository dirty, omitting update"; 
fi;

function do_bootstrap() {
  cd "$DIR/home"
  FILES=$(find . -maxdepth 1 -mindepth 1)
  for FILE in $FILES; do
    
    if [ -L ~/${FILE} ] ; then
      echo "${FILE} is already linked"
    else
      if [ -f ~/${FILE} ] ; then
        echo "${FILE} exists and is not a link, creating a backup"
        mkdir -p ${BACKUP_DIR}/${TIMESTAMP}
        mv ~/${FILE} ${BACKUP_DIR}/${TIMESTAMP}
      fi

      ln -s ${DIR}/home/${FILE} ~
    fi
    
  done
}

OS_PRERUN_SCRIPT="${DIR}/${OS}/pre_run.sh"

if [ -e ${OS_PRERUN_SCRIPT} ]; then
  echo  "running os pre-run script ${OS_PRERUN_SCRIPT}..."
  eval ${OS_PRERUN_SCRIPT}
  echo "done"
else
  echo "no os pre-run script found ${OS_PRERUN_SCRIPT}"
fi

do_bootstrap;
unset do_bootstrap;

