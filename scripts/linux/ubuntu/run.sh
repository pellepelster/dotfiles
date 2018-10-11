if [ ! -d ${HOME}/.oh-my-zsh ] ; then
  {
    cd ~
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  }
fi

if [ -z ${ZSH+x} ]; then
  echo "shell ist not zsh, changing default shell to zsh"
  chsh -s /bin/zsh
fi

RUBY_VERSION="2.4.0"
if [ ! -d ~/.rbenv/versions/${RUBY_VERSION}/ ] ; then
  sudo apt-get install -y libssl-dev
  rbenv install ${RUBY_VERSION}
  rbenv global ${RUBY_VERSION}
fi
