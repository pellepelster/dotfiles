sudo apt-get update > /dev/null

if [ ! -f /etc/apt/sources.list.d/klaus-vormweg-awesome-*.list ] ; then
  sudo add-apt-repository ppa:klaus-vormweg/awesome
  sudo apt-get update
fi

