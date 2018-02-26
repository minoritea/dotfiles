# prevent loading the file if it was not changed
BASH_PROFILE_HASH=$(md5 < $HOME/.bash_profile)
[ "x$IS_BASH_PROFILE_LOADED" != "x" -a "x$IS_BASH_PROFILE_LOADED" = "x$BASH_PROFILE_HASH" ] \
  && return
export IS_BASH_PROFILE_LOADED=$BASH_PROFILE_HASH

#ADD variables

# prevent appending same paths to PATH again
if [ "x$ORIG_PATH" = "x" ];then
  export ORIG_PATH=$PATH
fi

export GOPATH=$HOME/go

# PATH
PATH=/usr/local/bin:/usr/local/sbin:$ORIG_PATH:$HOME/bin
PATH=$GOPATH/bin:$PATH
PATH=$HOME/.local/bin:$PATH
PATH="$HOME/.cargo/bin:$PATH"

export PATH

export EDITOR=$(which nvim)

export HISTSIZE=50000
export HISTFILESIZE=50000

export PS1='$(if [[ $? == 0 ]];then echo "\[\e[0;35m\]💕\[\e[m\]";else echo "\[\e[0;33m\]💔\[\e[m\]";fi) \[\e[0;34m\]\u\[\e[0;33m\]@\[\e[0;34m\]\H\[\e[m\] \[\e[1;35m\]\W\[\e[m\] \[\e[1;36m\]($(git-current-branch))\[\e[m\] \[\e[1;32m\]❯❯\[\e[m\] '

#load .bashrc
[ -r $HOME/.bashrc ] && . $HOME/.bashrc

export VTE_CJK_WIDTH=1

# history
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT='%Y-%m-%d %T '
export HISTSIZE=10000
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
