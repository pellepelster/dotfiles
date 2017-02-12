set -eu

PACKAGE_LIST="$1/packages.list"

if [ -f ${PACKAGE_LIST} ] ; then
  
  PACKAGES=$(cat ${PACKAGE_LIST})

  for PACKAGE in ${PACKAGES} ; do
    echo -n "installing ${PACKAGE}..."
    brew upgrade ${PACKAGE} || true
    echo "done"
  done

fi
