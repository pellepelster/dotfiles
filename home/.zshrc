export ZSH=/home/pelle/.oh-my-zsh

export GOPATH="${HOME}/go"
export RBENV_PATHPATH="$HOME/.rbenv/bin"
PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
export PATH="${RBENV_PATHPATH}:${HOME_DIR}/bin:$GOPATH/bin:$PATH:$EXTRA_PATH"

# do not display own name in prompt
DEFAULT_USER="cpelster"

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

# Add the following to your shell init to set up gpg-agent automatically for every shell
if [ -f ~/.gnupg/.gpg-agent-info ] && [ -n "$(pgrep gpg-agent)" ]; then
    source ~/.gnupg/.gpg-agent-info
    export GPG_AGENT_INFO
else
    eval $(gpg-agent --daemon --options ~/.gnupg/gpg-agent.conf --write-env-file ~/.gnupg/.gpg-agent-info)
fi

export GPGKEY=60665D73

