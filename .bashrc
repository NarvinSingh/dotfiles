#
# Prompt
#
PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \$ '

#
# Aliases
#

# ls
alias ls='ls --color=auto'
alias l='ls -al'
alias la='ls -A'
alias ll='ls -l'

# git
alias gl='git log --pretty="%n%C(yellow)%>(7,trunc)%h %Cgreen%s%w(,,8)%+b" --stat'
alias gls='git ls-tree -r --name-only HEAD'

# vim
alias vvim='vim -u NONE'

# dotfiles
alias df='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dfc='df checkout -f'
alias dfl='df log --pretty="%n%C(yellow)%>(7,trunc)%h %Cgreen%s%w(,,8)%+b" --stat'
alias dfls='df ls-tree -r --name-only HEAD'

