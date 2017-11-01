export ZSH=/home/pelle/.oh-my-zsh

export GOPATH="${HOME}/go"
export RBENV_PATHPATH="$HOME/.rbenv/bin"
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
export PATH="${RBENV_PATHPATH}:${HOME}/bin:$GOPATH/bin:$PATH:$EXTRA_PATH"

# do not display own name in prompt
DEFAULT_USER="pelle"

if ! xhost >& /dev/null ; then
  startx
  exit 0
fi

# avoid different backgirund coloirs for vim syntax highlighting
export TERM=xterm-256color
PROMPT="%\{%f%b%k%\}\$\(build_prompt\)"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="pelle"

# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(shrink-path colored-man-pages zsh-syntax-highlighting history-substring-search)

source $ZSH/oh-my-zsh.sh
source $HOME/.zshrc.local

eval "$(rbenv init -)"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='vim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

GPG_TTY=$(tty)
export GPG_TTY

(gpg-connect-agent /bye > /dev/null)

export GPGKEY=87FA8362

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    (umask 066; /usr/bin/ssh-agent > "${SSH_ENV}")
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

if [ -f "${SSH_ENV}" ]; then
  . "${SSH_ENV}" > /dev/null
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
    start_agent;
fi

export JAVA_HOME=${$(readlink -f $(which java))%/bin/java}
export JAVA_HOME=${JAVA_HOME%/jre}

