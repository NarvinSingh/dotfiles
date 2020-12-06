# Compinstall
# ===========
zstyle :compinstall filename "${XDG_CONFIG_HOME}/zsh/.zshrc"
autoload -Uz compinit

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

# Bindings
# ========
bindkey -v

# History
# =======
mkdir -p "${XDG_DATA_HOME}/zsh"
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=1000
SAVEHIST=1000

# Modules
# =======
for module in "${XDG_CONFIG_HOME}"/zsh/mod-{aliases,prompt}; do
  if [[ -r "${module}" ]]; then source "${module}"; fi
done

