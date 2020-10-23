# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/narvin/.zshrc'

autoload -Uz compinit
# End of lines added by compinstall

# Environment
# ===========

# XDG Base Directory Specification
# --------------------------------

# See
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

# Compinit Redirection
# --------------------

# See
# https://unix.stackexchange.com/questions/391641/separate-path-for-zcompdump-files

mkdir -p "${XDG_CACHE_HOME}/zsh"
compinit -d "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"

# VIM Redirection
# ---------------

# See https://tlvince.com/vim-respect-xdg

export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

# Tmux Redirection
# ----------------

# Non-ideal solution of setting tmux to an alias the specifies the config file
alias tmux='tmux -f ~/.config/tmux/tmux.conf'

# Less Redirection
# ----------------
mkdir -p "${XDG_CACHE_HOME}"/less
export LESSHISTFILE="${XDG_CACHE_HOME}/less/history"

# Prompt
# ======

# Colors
# ------
CLR_BLACK=0
CLR_MAROON=1
CLR_GREEN=2
CLR_OLIVE=3
CLR_NAVY=4
CLR_PURPLE=5
CLR_TEAL=6
CLR_SILVER=7
CLR_GREY=8
CLR_RED=9
CLR_LIME=10
CLR_YELLOW=11
CLR_BLUE=12
CLR_FUCHSIA=13
CLR_AQUA=14
CLR_WHITE=15

PS_CLR_LAST_OK=$CLR_LIME
PS_CLR_LAST_ERR=$CLR_RED
PS_CLR_USER=$CLR_LIME
PS_CLR_AT=$CLR_LIME
PS_CLR_HOST=$CLR_LIME
PS_CLR_DIR=$CLR_BLUE
PS_CLR_GIT=$CLR_RED
PS_CLR_SYM=$CLR_GREY

git_get_branch() {
    git branch 2> /dev/null | sed -n 's/\*\s*\(.*\)/ (\1)/p'
}

# Prompt parts. They will be expanded once when assembled to form the prompt. If
# any portion of a part needs to be expanded each time the prompt is written,
# simply escape the $ for those portions.
PS_LAST="%(?.%F{$PS_CLR_LAST_OK}√.%F{$PS_CLR_LAST_ERR}%?)%f"
PS_USER="%F{$PS_CLR_USER}%n%f"
PS_SEP="%F{$PS_CLR_AT}@%f"
PS_HOST="%F{$PS_CLR_HOST}%m%f"
PS_DIR="%F{$PS_CLR_DIR}%~%f"
PS_GIT="%F{$PS_CLR_GIT}\$(git_get_branch)%f"
PS_SYM="%F{$PS_CLR_SYM}%#%f"

# Turn on prompt substitution and assemble the prompt. Use double quotes to
# expand the prompt parts right away. Dynamic portions have the $ escaped, so
# they will be expanded each time the prompt is written.
setopt prompt_subst
PS1="$PS_LAST ${PS_USER}${PS_SEP}${PS_HOST} ${PS_DIR}${PS_GIT} $PS_SYM "

# Aliases
# =======

# ls
# --
alias ls='ls --color=auto'
alias l='ls -al'
alias la='ls -A'
alias ll='ls -l'

# git
# ---
alias gl='git log --pretty="%n%C(yellow)%>(7,trunc)%h %Cgreen%s%w(,,8)%+b" --stat'
alias gls='git ls-tree -r --name-only HEAD'

# vim
# ---
alias vvim='vim -u NONE'

# dotfiles
# --------
alias cfg='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias cfgc='cfg checkout -f'
alias cfgl='cfg log --pretty="%n%C(yellow)%>(7,trunc)%h %Cgreen%s%w(,,8)%+b" --stat'
alias cfgls='cfg ls-tree -r --name-only HEAD'

# gitadd
# ------
alias gitadd='$HOME/project/linux/gitadd'
alias cfgadd='gitadd --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

