#!/usr/bin/env bash

set -eu

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_DIR="${DIR}/backup"
TIMESTAMP=$(date +%Y%m%d%H%M)
DRY_RUN=${DRY_RUN:-true}

if [ "${DRY_RUN}" = true ] ; then
  echo "Performing a dry run..."
fi

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
  {
    cd "${DIR}/home"
    link_files "" "$(realpath ~)"
  }
  { 
    cd "${DIR}/etc"
    link_files "" "/etc"
  }
}

function link_file() {
  local link_name=$1
  local link_target=$2
  local level=$3

  if [ -L ${link_name} ] ; then
    echo "$(indent $level)${link_name} is already linked"
    return 
  fi

  if [ -f ${link_name} ] || [ -d ${link_name} ] ; then
    echo "$(indent $level)${link_name} exists and is not a link, creating a backup"
    local backup_target="${BACKUP_DIR}/${TIMESTAMP}"
    local src="${link_name}"

    if [ "${DRY_RUN}" = true ] ; then
      echo "$(indent $level)[dry run] Would backup ${link_name} to ${backup_target}"
    else
      mkdir -p ${backup_target}
      if [ -w $(dirname ${link_name}) ] ; then
        echo "--"
        mv ${link_name} ${backup_target}
      else
        echo "ddd"
        sudo mv ${link_name} ${backup_target}
      fi
    fi

  fi

  if [ "${DRY_RUN}" = true ] ; then
    echo -n "$(indent $level)[dry run] Would link ${link_name} to ${link_target}"
    if [ -w $(dirname ${link_name}) ] ; then
      echo ""
    else
      echo " using sudo"
    fi
  else
    if [ -w $(dirname ${link_name}) ] ; then
      ln -s ${link_target} ${link_name}
    else
      sudo ln -s ${link_target} ${link_name}
    fi
  fi
}

function indent() {
  head -c $(($1*4)) < /dev/zero | tr '\0' ' '
}

function link_files() {
  local current_dir=$1
  local link_root=$2
  local level=$(echo "${current_dir}" | grep -o / | wc -l)

  echo "$(indent $level)looking for candidates in $(pwd)/${current_dir} to link to ${link_root}"
 
  level=$(($level+1))
  FILES=$(find ./${current_dir} -maxdepth 1 -mindepth 1 -not -name .do_not_link)
  for FILE in $FILES; do
    FILE=${FILE#./} 
    local link_name="${link_root}/${FILE}"

    echo -n "$(indent $level)candidate ${FILE}" 
    if [ -d ${FILE} ] ; then
      echo -n " is a directory"
      if [ -f ${FILE}/.do_not_link ] ; then
        echo " that should not be linked" 
        link_files ${FILE} ${link_root} 
      else
        echo " that should be linked"
        link_file "${link_name}" "$(pwd)/${FILE}" $(($level+1))
      fi
    else
      echo " is a file " 
      link_file "${link_name}" "$(pwd)/${FILE}" $(($level+1))
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

run_script_if_exists "scripts/${os_dir}/pre_run.sh" "os pre-run"
run_script_if_exists "scripts/${os_dir}/install_packages.sh" "package installation" "${DIR}/packages/${os_dir}"

do_bootstrap;
unset do_bootstrap;

