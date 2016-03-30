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

if ! type git-current-branch > /dev/null 2>&1;then
  alias git-current-branch=[ -e "$(pwd)/.git" ] && git rev-parse --abbrev-ref HEAD 2>/dev/null
fi

shopt -s histappend
