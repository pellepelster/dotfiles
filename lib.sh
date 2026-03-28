function ensure_link() {
    local source="${1:-}"
    local target="${2:-}"

    if [[ -z "${source}" || -z "${target}" ]]; then
        echo "Usage: ensure_link <source> <target>"
        return
    fi

    if [[ -L "${source}" && "$(readlink -f "${source}")" == "$(readlink -f "${target}")" ]]; then
        echo "source '${source}' is already linked to '${target}'"
        return
    fi

    if [[ -e "${source}" || -L "${source}" ]]; then
        local backup="${source%/}.backup.$(date +%Y%m%d%H%M%S)"
        echo "backing up source '${source}' to '${backup}"
        mv "${source}" "${backup}" || { echo "failed to back up '${source}'"; return; }
    fi

    echo "linking source '${source}' to target '${target}'"
    ln -s "${target}" "${source}" || { echo "failed to create link"; return; }
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