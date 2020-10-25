# Lines configured by zsh-newuser-install
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/narvin/.zshrc'

autoload -Uz compinit
# End of lines added by compinstall

# Environment
# ===========

# XDG Base Directory Specificatio
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

# History
# =======
mkdir -p "${XDG_DATA_HOME}/zsh"
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=1000
SAVEHIST=1000

# Prompt
# ======

# Colors
# ------

# ## Palette
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

# ## Scheme
PS_CLR_LAST_OK=${CLR_LIME}
PS_CLR_LAST_ERR=${CLR_RED}
PS_CLR_USER=${CLR_LIME}
PS_CLR_AT=${CLR_LIME}
PS_CLR_HOST=${CLR_LIME}
PS_CLR_DIR=${CLR_BLUE}
PS_CLR_GIT_C=${CLR_WHITE}
PS_CLR_BG_GIT_C=${CLR_GREEN}
PS_CLR_GIT_D=${CLR_WHITE}
PS_CLR_BG_GIT_D=${CLR_MAROON}
PS_CLR_GIT_S=${CLR_MAROON}
PS_CLR_BG_GIT_S=${CLR_WHITE}
PS_CLR_SYM=${CLR_GREY}

# Git
# ---

git_path=$(which git)

if [[ "$?" -ne 0 ]]; then
  git_path=''
fi

get_git_status() {
  # Git is installed
  if [[ -n "${git_path}" ]]; then
    stat=$("${git_path}" status --porcelain=v2 --branch 2> /dev/null)

    # Inside a repo so generate and output the status
    if [[ "$?" -eq 0 ]]; then
      # Parse the branch and fallback to a default value
      branch=${$(printf '%s' "${stat}" \
        | grep '^# branch.head ' -m 1 | cut -b 15-):-???}

      # Parse ahead and behind
      ab=$(printf '%s' "${stat}" | grep '^# branch.ab ' -m 1)
      ah=$(printf "${ab}" | cut -d '+' -f 2 | cut -d ' ' -f 1)
      bh=$(printf "${ab}" | cut -d '-' -f 2)

      # Parse the changes
      num_a=$(printf '%s' "${stat}" | grep '^[12u] A' -c)
      num_m=$(printf '%s' "${stat}" | grep -E '^[12u] (M|.M)' -c)
      num_d=$(printf '%s' "${stat}" | grep -E '^[12u] (D|.D)' -c)
      num_r=$(printf '%s' "${stat}" | grep -E '^[12u] (R|.R)' -c)
      num_c=$(printf '%s' "${stat}" | grep -E '^[12u] (C|.C)' -c)
      num_u=$(printf '%s' "${stat}" | grep '^? ' -c)
      total=$(printf '%s' "${stat}" | grep '^[12u?] ' -c)

      # Construct the stats
      stats=''

      if [[ -n "${ah}" && "${ah}" -gt 0 ]]; then stats+=" +${ah}"; fi
      if [[ -n "${bh}" && "${bh}" -gt 0 ]]; then stats+=" -${bh}"; fi
      if [[ "${num_a}" -gt 0 ]]; then stats+=" a${num_a}"; fi
      if [[ "${num_m}" -gt 0 ]]; then stats+=" m${num_m}"; fi
      if [[ "${num_d}" -gt 0 ]]; then stats+=" d${num_d}"; fi
      if [[ "${num_r}" -gt 0 ]]; then stats+=" r${num_r}"; fi
      if [[ "${num_c}" -gt 0 ]]; then stats+=" c${num_c}"; fi
      if [[ "${num_u}" -gt 0 ]]; then stats+=" u${num_u}"; fi

      # Output the stats
      printf ' ' # Print the leading spacer

      # No changes, so the branch is clean. It may still be ahead or behind.
      if [[ "${total}" -eq 0 ]]; then
        printf "%%K{${PS_CLR_BG_GIT_C}} %%F{${PS_CLR_GIT_C}}${branch}%%f %%k"

      # Changes, so the branch is dirty. It may also be ahead or behind.
      else
        printf "%%K{${PS_CLR_BG_GIT_D}} %%F{${PS_CLR_GIT_D}}${branch}%%f %%k"
      fi

      # A clean branch may have stats because it is ahead or behind. A dirty
      # branch may not have stats if there are changes we didn't check for,
      # i.e., total > 0 and stats = ''.
      if [[ -n "${stats}" ]]; then
        printf "%%K{${PS_CLR_BG_GIT_S}}%%F{${PS_CLR_GIT_S}}${stats}%%f %%k"
        #                              ^ If not empty, stats has a leading space
      fi
    fi
  fi

  # If we are in a repo we have to output a trailing space, and if we are
  # not in a repo or Git is not installed, we have to output a space
  printf ' '
}

# Prompt Parts
# ------------

# Each part will be expanded once when assembled to form the prompt. If any
# portion of a part needs to be expanded each time the prompt is written,
# simply escape the $ for those portions.
PS_LAST="%(?.%F{$PS_CLR_LAST_OK}√.%F{$PS_CLR_LAST_ERR}%?)%f"
PS_USER="%F{$PS_CLR_USER}%n%f"
PS_SEP="%F{$PS_CLR_AT}@%f"
PS_HOST="%F{$PS_CLR_HOST}%m%f"
PS_DIR="%F{$PS_CLR_DIR}%~%f"
PS_GIT="\$(get_git_status)"
PS_SYM="%F{$PS_CLR_SYM}%#%f"

# Turn on prompt substitution and assemble the prompt. Use double quotes to
# expand the prompt parts right away. Dynamic portions have the $ escaped, so
# they will be expanded each time the prompt is written.
setopt prompt_subst
PS1="${PS_LAST} ${PS_USER}${PS_SEP}${PS_HOST} ${PS_DIR}${PS_GIT}${PS_SYM} "

# Aliases
# =======

# ls
# --
alias ls='ls --color=auto'
alias l='ls -al'
alias la='ls -A'
alias ll='ls -l'

# cp
# --
alias cp='cp -i'

# rm
# --
alias rm='rm -i'

# tmux
# ----
alias t='tmux'

# vim
# ---
alias v='vim'
alias vv='v -u NONE'

