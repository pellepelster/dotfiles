set -eu

PACKAGE_LIST="$1/packages.list"

if [ -f ${PACKAGE_LIST} ] ; then
  
  PACKAGES=$(cat ${PACKAGE_LIST})

  for PACKAGE in ${PACKAGES} ; do
    echo -n "installing ${PACKAGE}..."
    sudo apt-get -q -y install ${PACKAGE}
    echo "done"
  done

fi
