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
PS_CLR_GIT_S_X=${CLR_GREEN}
PS_CLR_GIT_S_Y=${CLR_MAROON}
PS_CLR_BG_GIT_S=${CLR_WHITE}
PS_CLR_SYM=${CLR_GREY}

# Git
# ---

git_path=$(which git)

if [[ "$?" -ne 0 ]]; then
  git_path=''
fi

get_xy_stats() {
  code="${1}"
  num_x="${2}"
  num_y="${3}"
  res=''

  if [[ "${num_x}" -gt 0 || "${num_y}" -gt 0 ]]; then
    res+=" %%F{${PS_CLR_GIT_S}}${code}%%f"

    if [[ "${num_x}" -gt 0 ]]; then res+="%%F{${PS_CLR_GIT_S_X}}${num_x}%%f"; fi
    if [[ "${num_y}" -gt 0 ]]; then
      res+="%%F{${PS_CLR_GIT_S}}:%%f%%F{${PS_CLR_GIT_S_Y}}${num_y}%%f"
    fi
  fi

  printf '%s' "${res}"
}

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
      a=$(printf "${ab}" | cut -d '+' -f 2 | cut -d ' ' -f 1)
      b=$(printf "${ab}" | cut -d '-' -f 2)

      # Parse the changes
      num_a=$(printf '%s' "${stat}" | grep '^[12u] A' -c)
      num_mx=$(printf '%s' "${stat}" | grep -E '^[12u] M' -c)
      num_my=$(printf '%s' "${stat}" | grep -E '^[12u] .M' -c)
      num_dx=$(printf '%s' "${stat}" | grep -E '^[12u] D' -c)
      num_dy=$(printf '%s' "${stat}" | grep -E '^[12u] .D' -c)
      num_rx=$(printf '%s' "${stat}" | grep -E '^[12u] R' -c)
      num_ry=$(printf '%s' "${stat}" | grep -E '^[12u] .R' -c)
      num_cx=$(printf '%s' "${stat}" | grep -E '^[12u] C' -c)
      num_cy=$(printf '%s' "${stat}" | grep -E '^[12u] .C' -c)
      num_u=$(printf '%s' "${stat}" | grep '^? ' -c)
      total=$(printf '%s' "${stat}" | grep '^[12u?] ' -c)

      # Construct the stats
      stats=''

      if [[ -n "${a}" && "${a}" -gt 0 ]]; then stats+=" +${a}"; fi
      if [[ -n "${b}" && "${b}" -gt 0 ]]; then stats+=" -${b}"; fi

      stats+=$(get_xy_stats 'a' "${num_a}")
      stats+=$(get_xy_stats 'm' "${num_mx}" "${num_my}")
      stats+=$(get_xy_stats 'd' "${num_dx}" "${num_dy}")
      stats+=$(get_xy_stats 'r' "${num_rx}" "${num_ry}")
      stats+=$(get_xy_stats 'c' "${num_cx}" "${num_cy}")
      stats+=$(get_xy_stats 'u' "${num_ux}" "${num_uy}")

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

