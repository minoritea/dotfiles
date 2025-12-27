stty -ixon

# prevent appending same paths to PATH again
if [ "x$ORIG_PATH" = "x" ];then
  export ORIG_PATH=$PATH
fi

# PATH
PATH="$ORIG_PATH:$HOME/.local/bin"
export PATH

status_mark() {
  if [[ "x$?" = "x0" ]]; then
    echo "🧡"
  else
    echo "💔"
  fi
}

show_branch() {
  local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ ! -z "$BRANCH" ]; then
    echo -e "\e[48;5;68;38;5;254m▶︎\e[48;5;68;38;5;52m ${BRANCH} \e[0;38;5;68m▶︎"
  else
    echo -e "\e[0;38;5;254m▶︎"
  fi
}

export PS1='
$(status_mark) \e[48;5;229;38;5;0m▶︎\e[48;5;229;38;5;52m \D{%Y-%m-%dT%H:%M:%S} \e[48;5;72;38;5;229m▶︎\e[48;5;72;38;5;52m \u \e[48;5;254;38;5;72m▶︎\e[48;5;254;38;5;52m \w $(show_branch)\e[m
 > '

# history
export HISTSIZE=-1
export HISTFILESIZE=-1
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT='%Y-%m-%d %T '
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
shopt -s histappend

if [ -f /usr/share/bash-completion/bash_completion ];then
  . /usr/share/bash-completion/bash_completion
fi

if ! type git-current-branch > /dev/null 2>&1;then
  alias git-current-branch='git rev-parse --abbrev-ref HEAD 2>/dev/null'
fi

hp() {
  local action
  action=`curl -N -s localhost:14444 | peco`
  READLINE_LINE="${action}"
  READLINE_POINT="${#READLINE_LINE}"
}

bind -x '"\C-r": hp'
bind    '"\C-xr": hp'

md() {
  mkdir -p "$1" && cd "$1"
}

mt() {
  mkdir -p $(dirname $@) && touch $@
}

git_push_origin_current_branch() {
  git push origin $(git-current-branch) $@
}
alias git-push-origin-current-branch="git_push_origin_current_branch"

git_pull_origin_current_branch() {
  git pull origin $(git-current-branch) $@
}
alias git-pull-origin-current-branch="git_pull_origin_current_branch"

export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/.ripgreprc

for f in $HOME/.bashrc.d/*sh;do
  [ -e $f ] && . $f
done

eval "$(mise activate bash)"
if pgrep history-watcher > /dev/null;then 
  echo "history-watcher daemon already started."
else
  HW_POLL=1 HW_DBFILE=$HOME/.cache/history-watcher.db goemon -- history-watcher > /dev/null
  echo "history-watcher daemon starts..."
fi

export EDITOR=nvim
alias vim=nvim
