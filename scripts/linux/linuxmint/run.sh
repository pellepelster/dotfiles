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

