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

function md() {
  mkdir -p $@ && cdabs $@
}

if ! type git-current-branch > /dev/null 2>&1;then
  alias git-current-branch=[ -e "$(pwd)/.git" ] && git rev-parse --abbrev-ref HEAD 2>/dev/null
fi

shopt -s histappend

bind -x '"\C-r": hp'
bind    '"\C-xr": reverse-search-history'

alias vim=nvim
