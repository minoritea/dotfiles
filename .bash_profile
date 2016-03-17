#ADD variables
export PATH=/usr/local/bin:/usr/local/sbin:$PATH:$HOME/bin
export EDITOR=$(which nvim)
export PS1='$(if [[ $? == 0 ]];then echo "\[\e[0;35m\]✓\[\e[m\]";else echo "\[\e[0;33m\]✗\[\e[m\]";fi) \[\e[0;34m\]\u\[\e[0;33m\]@\[\e[0;34m\]\H\[\e[m\] \[\e[1;35m\]\W\[\e[m\] \[\e[1;36m\]($(git-current-branch))\[\e[m\] \[\e[1;32m\]❯❯\[\e[m\] '
#\[\e[1;37m\]'

#load .bashrc
[ -r $HOME/.bashrc ] && . $HOME/.bashrc
