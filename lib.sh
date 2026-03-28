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
  if pass backup/s3_access_key &> /dev/null; then
    export AWS_ACCESS_KEY_ID=$(pass backup/s3_access_key)
  fi
  if pass backup/s3_secret_key &> /dev/null; then
    export AWS_SECRET_ACCESS_KEY=$(pass backup/s3_secret_key)
  fi
}

ensure_package() {
    local package="$1"
    if ! dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
        echo "Installing '${package}'"
        sudo apt-get install -y "${package}"
    else
        echo "${package} is already installed"
    fi
}

ensure_file() {
    local source="${1}"
    local target="${2}"

    if [ ! -f "${source}" ]; then
        echo "source file '${source}' does not exist." >&2
        return
    fi

    if [ -f "${target}" ]; then
        local source_sum target_sum
        source_sum=$(sha256sum "${source}" | awk '{print $1}')
        target_sum=$(sha256sum "${target}" | awk '{print $1}')

        if [ "${source_sum}" = "${target_sum}" ]; then
            echo "'${target}' is already up to date"
            return
        fi
    fi

    echo "Copying '${source}' to '${target}'..."
    cp "${source}" "${target}"
}