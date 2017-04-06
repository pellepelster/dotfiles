set +eu

sudo apt-get update > /dev/null

if [ ! -f /etc/apt/sources.list.d/klaus-vormweg-awesome-*.list ] ; then
  sudo add-apt-repository ppa:klaus-vormweg/awesome
  sudo apt-get update
fi

if ! which termite ; then
  git clone https://github.com/Corwind/termite-install.git /tmp/termite
  echo "a7e75cb68819fb90f9e6834ddb66bb8654ff5d29c5a3997716db5c994de94f23 /tmp/termite/termite-install.sh"  | sha256sum -c || exit 1
  /tmp/termite/termite-install.sh
fi

if [ ! -f ~/.local/share/fonts/ter-powerline-x12b.pcf.gz ] ; then
  git clone https://github.com/powerline/fonts.git /tmp/powerline-fonts
  /tmp/powerline-fonts/install.sh
fi
