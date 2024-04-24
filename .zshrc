# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
# nix
export PATH=$HOME/.nix-profile/bin:$PATH
export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
ZSH_THEME="amuse"
SOLARIZED_THEME="dark"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git asdf colored-man-pages gitignore fzf)

source $ZSH/oh-my-zsh.sh

# User configuration

# export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

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
alias c='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias W="watch"
alias t="tig --all"
alias kubectl="echo '!!! UNSECURE !!!' && kubectl --insecure-skip-tls-verify"
alias docker="sudo docker"

# debian environment variables
export DEBFULLNAME="Miroslav Gajdos"
export DEBEMAIL="miroslav.gajdos@firma.seznam.cz"

export EDITOR='vim'
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
export _JAVA_AWT_WM_NONREPARENTING=1

DICK_PREPARE="useradd $(whoami) -u $(id -u); passwd -d $(whoami); su $(whoami); exec /bin/bash"
dch() {
    docker container run --rm -it -e "DEBFULLNAME" -e "DEBEMAIL" -v $(pwd):/mount -w "/mount" docker.dev.dszn.cz/debian:stretch-stable-build dch $@
}
dick() {
    #docker container run --rm -it -e "DEBFULLNAME" -e "DEBEMAIL" -v $(pwd):/mount -w "/mount" $@ /bin/bash -c "adduser $(whoami) -u $(id -u) --disabled-password --gecos ''; su $(whoami); exec /bin/bash"
    #docker container run --rm -it -v $(pwd):/mount/host -w "/mount/host" $@ /bin/bash -c "$DICK_PREPARE"
    docker container run --rm -it -v $(pwd):/mount/host -w "/mount/host" $1 /bin/bash -c "$DICK_PREPARE"
    # todo:
    # apt update && apt install git...
    # - config git
    #       git config --global user.email "miroslav.gajdos@firma.seznam.cz"
    #       git config --global user.name "Gajdos, Miroslav"
}
dicknet() {
    docker container run --network=$2 --rm -it -v $(pwd):/mount/host -w "/mount/host" $1 /bin/bash -c "$DICK_PREPARE"
}
dicksysd() {
    docker container run --rm -ti --tmpfs /tmp --tmpfs /run -v $(pwd):/mount/host -w "/mount/host" -v /sys/fs/cgroup:/sys/fs/cgroup:ro $1 /bin/bash -c "$DICK_PREPARE"
}
kubedick() {
    kubectl run bash --rm -it --image $@
}

source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

# include host configuration
if [ -r ~/.zshrc.`cat /etc/hostname` ]; then
    source ~/.zshrc.`cat /etc/hostname`
fi
# include local configuration
if [ -r ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
