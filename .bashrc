#load /etc/bashrc
if [ "x" = "x$ETC_BASHRC_LOADED" -a -e /etc/bashrc ];then
  . /etc/bashrc
  export ETC_BASHRC_LOADED=ok
fi

##### ↓↓ variables #####

# prevent appending same paths to PATH again
if [ "x$ORIG_PATH" = "x" ];then
  export ORIG_PATH=$PATH
fi

export GOPATH=$HOME/go

# PATH
PATH="/usr/local/bin:/usr/local/sbin:$ORIG_PATH"
PATH="$GOPATH/bin:$PATH"
PATH="$HOME/.local/var/lib/ruby-build/2.6.1/bin:$PATH"
# PATH=$HOME/.local/var/lib/node-build/9.11.1/bin:$PATH
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
# PATH="$HOME/projects/scripts/bin:$PATH"
# PATH="$PATH:/Applications/Julia-0.6.app/Contents/Resources/julia/bin"
# PATH="/usr/local/opt/avr-gcc@8/bin:$PATH"

export PATH

export EDITOR=$(which nvim)

export HISTSIZE=100000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth

export PS1='
$(if [[ $? == 0 ]];then echo "\[\e[35m\]🧡";else echo "\[\e[32m\]💔";fi) \[\e[33m\]\u\[\e[34m\] \D{%Y-%m-%dT%H:%M:%S}\[\e[m\] \[\e[1;36m\]$(BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null);if [ ! -z "$BRANCH" ];then echo [$BRANCH];fi)
\[\e[1;34m\]At \[\e[1;35m\]\w\[\e[m\]
\[\e[1;32m\]❯\[\e[m\] '
# export PS1='$(if [[ $? == 0 ]];then echo "\[\e[0;35m\]OK\[\e[m\]";else echo "\[\e[0;33m\]NG\[\e[m\]";fi) \[\e[0;34m\]\u\[\e[0;33m\] @ \[\e[0;34m\]$(date "+%Y-%m-%d %H:%M:%S") \[\e[m\] \[\e[1;35m\]\W\[\e[m\] \[\e[1;36m\]($(git-current-branch))\[\e[m\] \[\e[1;32m\]❯❯\[\e[m\] '

export VTE_CJK_WIDTH=1

# history
export HISTTIMEFORMAT='%Y-%m-%d %T '
export HISTSIZE=100000
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

##### ↑↑ variables #####

#load direnv
if type pyenv >/dev/null 2>&1;then
  eval "$(pyenv init -)"
fi

if type direnv >/dev/null 2>&1;then
  export DIRENV_CONFIG=$HOME/.config/direnv
  eval "$(direnv hook bash)"
fi

if uname | grep Darwin > /dev/null 2>&1;then
  alias ls="ls -G"

  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
  alias ctags="`brew --prefix`/bin/ctags"
else
  alias ls="ls --color"

  if [ -f /usr/share/bash-completion/bash_completion ];then
    . /usr/share/bash-completion/bash_completion
  fi

fi

alias vim=nvim
alias docker-stop-all='docker ps -q | xargs docker stop'

function get_abs_dir() {
  cmd=readlink
  if [ -x "$(command -v greadlink)" ];then
    cmd=greadlink
  fi
  [ ! -e "$1" ] && return 1
  cdir="$(pwd)"
  cd "$(${cmd} -f "$1")"
  echo "$(pwd)"
  cd "$cdir"
}

function cdabs() {
  target_dir="$(get_abs_dir $([ "x$1" == "x" ]  && echo -n "." || echo -n "$1"))"
  cmdret=$?
  [ $cmdret -ne 0 ] && echo "cannot find the target path: $1" 1>&2 && return $cmdret
  [ ! -e "$target_dir" ] && return 1
  cd "$target_dir"
}
alias ca=cdabs

if ! type git-current-branch > /dev/null 2>&1;then
  alias git-current-branch='git rev-parse --abbrev-ref HEAD 2>/dev/null'
fi

shopt -s histappend

if [ -e /tmp/history-watcher.lock ];then
  if ! pgrep -F /tmp/history-watcher.pid >/dev/null;then
    rm /tmp/history-watcher.lock /tmp/history-watcher.pid
    history_watcher_tempfile_not_exists=1
  fi
else
  history_watcher_tempfile_not_exists=1
fi

if [ "x" != "x$history_watcher_tempfile_not_exists" ];then
  echo "history-watcher daemon starts..."
  daemonize -p /tmp/history-watcher.pid -l /tmp/history-watcher.lock -e /tmp/history-watcher.log -a $GOPATH/bin/history-watcher
fi

function hp() {
  local action
  action=`curl -N -s localhost:14444 | peco`
  READLINE_LINE="${action}"
  READLINE_POINT="${#READLINE_LINE}"
}

bind -x '"\C-r": hp'
bind    '"\C-xr": hp'

function md() {
  mkdir -p "$1" && cdabs "$1"
}

function mt() {
  mkdir -p $(dirname $@) && touch $@
}

function git-push-origin-current-branch() {
  git push origin $(git-current-branch) $@
}

function git-pull-origin-current-branch() {
  git pull origin $(git-current-branch) $@
}

function ymd() {
  date +%Y%m%d
}

if uname | grep Darwin > /dev/null 2>&1;then
  export TMUX_TMPDIR=/private/tmp
fi

[ -z "$NO_USE_TMUX" -a -z "$TMUX" ] && (tmux attach || tmux new-session)

export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc
