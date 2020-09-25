#
# Prompt
#
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

#
# Aliases
#

# ls
alias l='ls -al'
alias la='ls -A'
alias ll='ls -l'

# dotfiles
alias df='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dfd='df checkout -f'
alias dfl='df ls-tree -r --name-only'
alias dflh='dfl HEAD'

