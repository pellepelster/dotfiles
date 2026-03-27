function ensure_dir_link() {
    local source_dir="${1:-}"
    local target_dir="${2:-}"

    if [[ -z "${source_dir}" || -z "${target_dir}" ]]; then
        echo "Usage: link_dir <source_dir> <target_dir>"
        return
    fi

    if [[ -L "${source_dir}" && "$(readlink -f "${source_dir}")" == "$(readlink -f "${target_dir}")" ]]; then
        echo "source dir '${source_dir}' is already linked to '${target_dir}'"
        return
    fi

    if [[ -e "${source_dir}" || -L "${source_dir}" ]]; then
        local backup_dir="${source_dir%/}.backup.$(date +%Y%m%d%H%M%S)"
        echo "backing up source dir '${source_dir}' to '${backup_dir}"
        mv "${source_dir}" "${backup_dir}" || { echo "failed to back up '${source_dir}'"; return; }
    fi

    echo "linking source dir '${source_dir}' to target dir '${target_dir}'"
    ln -s "${target_dir}" "${source_dir}" || { echo "failed to create link"; return; }
}

function ensure_backup_env() {
  if pass backup/password &> /dev/null; then
    export RESTIC_PASSWORD=$(pass backup/password)
  fi
}
