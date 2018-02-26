#load direnv
if type pyenv >/dev/null 2>&1;then
  eval "$(pyenv init -)"
fi

if type direnv >/dev/null 2>&1;then
  eval "$(direnv hook bash)"
fi

if uname | grep Darwin > /dev/null 2>&1;then
  alias ls="ls -G"

  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
else
  alias ls="ls --color"

  if [ -f /usr/share/bash-completion/bash_completion ];then
    . /usr/share/bash-completion/bash_completion
  fi

fi

alias vim=nvim
alias ctags="`brew --prefix`/bin/ctags"
alias docker-stop-all='docker ps -q | xargs docker stop'

function get_abs_dir() {
  [ ! -e $1 ] && return 1
  cdir=$(pwd)
  cd $(greadlink -f $1)
  echo $(pwd)
  cd $cdir
}

function cdabs() {
  target_dir=$(get_abs_dir $([ "x$1" == "x" ]  && echo -n "." || echo -n "$1"))
  cmdret=$?
  [ $cmdret -ne 0 ] && return $cmdret
  [ ! -e $target_dir ] && return 1
  cd $target_dir
}

if ! type git-current-branch > /dev/null 2>&1;then
  alias git-current-branch=[ -e "$(pwd)/.git" ] && git rev-parse --abbrev-ref HEAD 2>/dev/null
fi

shopt -s histappend

function hp() {
  local action
  # Look up event with peco.
  action="$(history | peco | cut -c 28-)"
  # Store event in history.
  history -s "${action}"
  # Execute.
  eval "${action}"
}

bind -x '"\C-r": hp'
bind    '"\C-xr": reverse-search-history'

function coffeelint() {
  command coffeelint -f "$HOME/.config/coffeelint/coffeelint.json" $@
}

function md() {
  mkdir -p $@ && cdabs $@
}

function mt() {
  mkdir -p $(dirname $@) && touch $@
}

function git-push-origin-current-branch() {
  git push origin $(git-current-branch) $@
}

function wd2gopath() {
  local target="$(cdabs $1;pwd)"
  local gopath_src="$(cdabs $GOPATH/src;pwd)/"
  echo ${target#${gopath_src}}
}

function pgoose() {
  [ "x$1" = "x" -o "x$2" = "x" ] && exit 1
  local dir="$1"
  local dbname="$2"
  shift 2
  goose -dir "$dir" postgres "host=localhost dbname=${dbname} user=root sslmode=disable" $@
}
