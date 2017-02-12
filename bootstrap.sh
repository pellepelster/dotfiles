#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="${DIR}/backup"
TIMESTAMP=$(date +%Y%m%d%H%M)

if [ ! -d ${BACKUP_DIR} ] ; then
  mkdir ${BACKUP_DIR} || true
fi

OS="none"
DISTRIB_ID='none'

echo -n "detecting os..."
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "mac os"
  OS="macos"
else
  echo "assuming linux"
  OS="linux"
  if [ -f "/etc/lsb-release" ]; then
    source /etc/lsb-release
  fi

  DISTRIB_ID=$(echo ${DISTRIB_ID} | tr '[:upper:]' '[:lower:]')
  echo "distribution ${DISTRIB_ID}"
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

(
  cd ${DIR}
  if [[ $(git ls-files -m | wc -l) -eq 0 ]]; then 
    echo -n "updating repository..."
    git pull origin master && echo "done";
  else 
    echo "repository dirty, omitting update"; 
  fi
)

function do_bootstrap() {
  cd "$DIR/home"
  FILES=$(find . -maxdepth 1 -mindepth 1)
  for FILE in $FILES; do
    
    if [ -L ~/${FILE} ] ; then
      echo "${FILE} is already linked"
    else
      if [ -f ~/${FILE} ] || [ -d ~/${FILE} ] ; then
        echo "${FILE} exists and is not a link, creating a backup"
        mkdir -p ${BACKUP_DIR}/${TIMESTAMP}
        mv ~/${FILE} ${BACKUP_DIR}/${TIMESTAMP}
      fi

      ln -s ${DIR}/home/${FILE} ~
    fi
    
  done
}

function run_script_if_exists() {
  local script_path=$1
  local script_name=$2
  shift 2

  local full_script="${DIR}/${script_path}"
  if [ -e ${full_script} ]; then
    echo  "running ${script_name} script ${full_script}..."
    eval "${full_script} $@"
    echo "done"
  else
    echo "no ${script_name} script found ${full_script}"
  fi
}

if [ ! ${OS} = 'linux' ] ; then
  os_dir=${OS}
else
  os_dir=${OS}/${DISTRIB_ID}
fi

run_script_if_exists "scripts/${os_dir}/re_run.sh" "os pre-run"
run_script_if_exists "scripts/${os_dir}/install_packages.sh" "package installation" "${DIR}/packages/${os_dir}"

do_bootstrap;
unset do_bootstrap;

