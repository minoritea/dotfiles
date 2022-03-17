stty -ixon

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

PATH="$HOME/.local/var/lib/ruby-build/3.1.0/bin:$PATH"
PATH="$HOME/.local/var/lib/node-build/14.17.4/bin:$PATH"

PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"

if uname | grep Linux > /dev/null 2>&1;then
  PATH="/usr/local/go/bin:$PATH"
fi

export PATH

function status-mark() {
  if [[ "x$?" = "x0" ]]; then
    echo "🧡"
  else
    echo "💔"
  fi
}

function show-branch() {
  local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ ! -z "$BRANCH" ]; then
    echo -e "\e[48;5;68;38;5;254m▶︎\e[48;5;68;38;5;52m ${BRANCH} \e[0;38;5;68m▶︎"
  else
    echo -e "\e[0;38;5;254m▶︎"
  fi
}

export PS1='
$(status-mark) \e[48;5;229;38;5;0m▶︎\e[48;5;229;38;5;52m \D{%Y-%m-%dT%H:%M:%S} \e[48;5;72;38;5;229m▶︎\e[48;5;72;38;5;52m \u \e[48;5;254;38;5;72m▶︎\e[48;5;254;38;5;52m \w $(show-branch)\e[m 
 > '

export VTE_CJK_WIDTH=1

# history
export HISTSIZE=-1
export HISTFILESIZE=-1
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='%Y-%m-%d %T '
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
shopt -s histappend

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

export EDITOR=$(which nvim)
alias vim=nvim

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
  HW_DBFILE=$HOME/.cache/history-watcher.db daemonize -p /tmp/history-watcher.pid -l /tmp/history-watcher.lock -e /tmp/history-watcher.log -a $GOPATH/bin/history-watcher
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

if uname | grep Darwin > /dev/null 2>&1;then
  export TMUX_TMPDIR=/private/tmp
fi
[ -z "$NO_USE_TMUX" -a -z "$TMUX" ] && (tmux attach || tmux new-session)

export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc

for f in $HOME/.bash.d/*sh;do
  [ -e $f ] && . $f
done
