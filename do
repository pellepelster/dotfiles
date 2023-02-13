#!/usr/bin/env bash

set -eu

DIR="$( cd "$(dirname "$0")" ; pwd -P )"

function task_bootstrap {
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${HOME}/bin"
}

function task_usage {
  echo "Usage: $0 bootstrap"
  exit 1
}

arg=${1:-}
shift || true
case ${arg} in
  bootstrap) task_bootstrap "$@" ;;
  *) task_usage ;;
esac
