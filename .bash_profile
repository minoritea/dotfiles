#ADD variables
if [ "x$ORIG_PATH" = "x" ];then
  export ORIG_PATH=$PATH
fi
PATH=/usr/local/bin:/usr/local/sbin:$ORIG_PATH:$HOME/bin
export EDITOR=$(which nvim)

export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT='%Y-%m-%d %T '

export PS1='$(if [[ $? == 0 ]];then echo "\[\e[0;35m\]💕\[\e[m\]";else echo "\[\e[0;33m\]💔\[\e[m\]";fi) \[\e[0;34m\]\u\[\e[0;33m\]@\[\e[0;34m\]\H\[\e[m\] \[\e[1;35m\]\W\[\e[m\] \[\e[1;36m\]($(git-current-branch))\[\e[m\] \[\e[1;32m\]❯❯\[\e[m\] '

#load .bashrc
[ -r $HOME/.bashrc ] && . $HOME/.bashrc
export GOPATH=$HOME/go

PATH=$GOPATH/bin:$PATH
PATH=$HOME/bin/.ruby-build/2.4.2/bin:$PATH
PATH=$HOME/bin/.node-build/8.2.1/bin:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/.cargo/bin:$PATH
export PATH
