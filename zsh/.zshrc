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

# Environment
# -----------
export POWERLINE=1

# Constants
# ---------

# ## Colors

# ### Palette
declare -i CLR_BLACK=0
declare -i CLR_MAROON=1
declare -i CLR_GREEN=2
declare -i CLR_OLIVE=3
declare -i CLR_NAVY=4
declare -i CLR_PURPLE=5
declare -i CLR_TEAL=6
declare -i CLR_SILVER=7
declare -i CLR_GREY=8
declare -i CLR_RED=9
declare -i CLR_LIME=10
declare -i CLR_YELLOW=11
declare -i CLR_BLUE=12
declare -i CLR_FUCHSIA=13
declare -i CLR_AQUA=14
declare -i CLR_WHITE=15

# ### Scheme
declare -i BG_TERM="${CLR_BLACK}"
declare -i FG_LAST_OK="${CLR_LIME}"
declare -i FG_LAST_ERR="${CLR_RED}"
declare -i FG_USER="${CLR_LIME}"
declare -i FG_SEP="${CLR_RED}"
declare -i FG_HOST="${CLR_LIME}"
declare -i FG_DIR="${CLR_BLUE}"
declare -i FG_GIT_CLEAN="${CLR_WHITE}"
declare -i BG_GIT_CLEAN="${CLR_GREEN}"
declare -i FG_GIT_DIRTY="${CLR_WHITE}"
declare -i BG_GIT_DIRTY="${CLR_MAROON}"
declare -i FG_GIT_STATS="${CLR_MAROON}"
declare -i FG_GIT_STATS_X="${CLR_GREEN}"
declare -i FG_GIT_STATS_Y="${CLR_MAROON}"
declare -i BG_GIT_STATS="${CLR_WHITE}"
declare -i FG_SYM="${CLR_GREY}"
declare -i FG_RIGHT="${CLR_GREY}"
declare -i FG_RIGHT_HL="${CLR_RED}"

# ## Symbols
declare PS_PL_LAST_OK=$'\u2713'
declare PS_LAST_OK=√
declare PS_PL_BRANCH_SYM=$' \ue0a0 '
declare PS_BRANCH_SYM=' '
declare PS_PL_TRANS_LEFT=$'\ue0b0'
declare PS_TRANS_LEFT='>'
declare PS_PL_TRANS=$'\ue0b2'
declare PS_TRANS=''
declare PS_PL_TRANS_2=$'\ue0b3'
declare PS_TRANS_2='<'

# Global Variables
# ----------------
declare ps_last=''
declare -i ps_last_len
declare ps_git=''
declare -i ps_git_len
declare ps_git_stats=''
declare -i ps_git_stats_len
declare -i ps_git_bg

# Last
# ----
function ps_last_update() {
  local -i code="${1}"
  local ok_sym="${2}"

  if [[ "${code}" -eq 0 ]]; then
    ps_last="%F{${FG_LAST_OK}}${ok_sym}%f"
    ps_last_len="${#ok_sym}"
  else
    ps_last="%F{${FG_LAST_ERR}}${code}%f"
    ps_last_len="${#code}"
  fi
}

# Git
# ---

# ## Init
declare git_path=$(which git)

if [[ "$?" -ne 0 ]]; then
  git_path=''
fi

# ## ps_git_stats_add
ps_git_stats_add() {
  local code="${1}"
  local -i num_x="${2}"
  local -i num_y="${3}"

  # Add a leading space, the code and the stats that are available to the
  # global status variable and increment the global length variable by the
  # number of printable characters added to the status.  The foreground
  # color is set at the beginning of the addition, and reset at the end of
  # the addition. The background color is inherited. A trailing space should
  # be added and the background color should be reset after the last stats.
  if [[ "${num_x}" -gt 0 || "${num_y}" -gt 0 ]]; then
    ps_git_stats+=" %F{${FG_GIT_STATS}}${code}"
    ps_git_stats_len+=$((1 + ${#code}))

    if [[ "${num_x}" -gt 0 ]]; then
      ps_git_stats+="%F{${FG_GIT_STATS_X}}${num_x}"
      ps_git_stats_len+=${#num_x}
    fi

    if [[ "${num_y}" -gt 0 ]]; then
      ps_git_stats+="%F{${FG_GIT_STATS}}:%F{${FG_GIT_STATS_Y}}${num_y}"
      ps_git_stats_len+=$((1 + ${#num_y}))
    fi

    ps_git_stats+='%f'
  fi
}

# ## ps_git_update
ps_git_update() {
  local -r trans="${1}"
  local -r branch_sym="${2}"

  # Init global variables
  ps_git_stats=''
  ps_git_stats_len=0
  ps_git=''
  ps_git_len=0
  ps_git_bg=0

  # Git is installed
  if [[ -n "${git_path}" ]]; then
    local data

    # Assign the variable in a separate step from declaring it so we get
    # the correct last exit code
    data="$(${git_path} status --porcelain=v2 --branch 2> /dev/null)"

    # Inside a repo so generate and output the status
    if [[ "$?" -eq 0 ]]; then
      local branch
      local ab
      local -i a
      local -i b
      local -i num_a
      local -i num_mx
      local -i num_my
      local -i num_dx
      local -i num_dy
      local -i num_rx
      local -i num_ry
      local -i num_cx
      local -i num_cy
      local -i num_um
      local -i num_uax
      local -i num_uay
      local -i num_udx
      local -i num_udy
      local -i num_u
      local -i total
      local -i clr_branch
      local -ri trans_len=${#trans}
      local -ri branch_sym_len=${#branch_sym}

      # Parse the branch and fallback to a default value
      branch=${$(print -r "${data}" \
        | grep -m 1 '^# branch.head ' | cut -b 15-):-???}

      # Parse ahead and behind
      ab=$(print -r "${data}" | grep -m 1 '^# branch.ab ')
      a=$(print -r "${ab}" | cut -d '+' -f 2 | cut -d ' ' -f 1)
      b=$(print -r "${ab}" | cut -d '-' -f 2)

      # Parse the changes
      num_a=$(print -r "${data}" | grep -c '^[12] A')
      num_mx=$(print -r "${data}" | grep -c '^[12] M')
      num_my=$(print -r "${data}" | grep -c '^[12] .M')
      num_dx=$(print -r "${data}" | grep -c '^[12] D')
      num_dy=$(print -r "${data}" | grep -c '^[12] .D')
      num_rx=$(print -r "${data}" | grep -c '^[12] R')
      num_ry=$(print -r "${data}" | grep -c '^[12] .R')
      num_cx=$(print -r "${data}" | grep -c '^[12] C')
      num_cy=$(print -r "${data}" | grep -c '^[12] .C')
      num_um=$(print -r "${data}" | grep -c '^u UU')
      num_uax=$(print -r "${data}" | grep -c '^u A')
      num_uay=$(print -r "${data}" | grep -c '^u .A')
      num_udx=$(print -r "${data}" | grep -c '^u D')
      num_udy=$(print -r "${data}" | grep -c '^u .D')
      num_u=$(print -r "${data}" | grep -c '^? ')
      total=$(print -r "${data}" | grep -c '^[12u?] ')

      # Construct the stats

      # Ahead
      if [[ -n "${a}" && "${a}" -gt 0 ]]; then
        ps_git_stats+=" %F{${FG_GIT_STATS}}↑%F{${FG_GIT_STATS_X}}${a}%f"
        ps_git_stats_len+=$((1 + 1 + ${#a}))
      fi

      # Behind
      if [[ -n "${b}" && "${b}" -gt 0 ]]; then
        # But not ahead
        if [[ -z "${stats}" ]]; then
          ps_git_stats+=' '
          ps_git_stats_len+=1
        fi

        ps_git_stats+="%F{${FG_GIT_S}}↓%F{${FG_GIT_STATS_X}}${b}%f"
        ps_git_stats_len+=$((1 + ${#b}))
      fi

      ps_git_stats_add 'a' "${num_a}"
      ps_git_stats_add 'm' "${num_mx}" "${num_my}"
      ps_git_stats_add 'd' "${num_dx}" "${num_dy}"
      ps_git_stats_add 'r' "${num_rx}" "${num_ry}"
      ps_git_stats_add 'c' "${num_cx}" "${num_cy}"
      ps_git_stats_add 'um' "${num_um}"
      ps_git_stats_add 'ua' "${num_uax}" "${num_uay}"
      ps_git_stats_add 'ud' "${num_udx}" "${num_udy}"
      ps_git_stats_add '?' "${num_u}"

      # Construct the git portion of the prompt, which will vary depending
      # on whether or not the stats are empty

      # Clean branch
      if [[ "${total}" -eq 0 ]]; then
        fg_branch=${FG_GIT_CLEAN}
        bg_branch=${BG_GIT_CLEAN}
        ps_git_bg=${BG_GIT_CLEAN}

      # Dirty branch
      else
        fg_branch=${FG_GIT_DIRTY}
        bg_branch=${BG_GIT_DIRTY}
        ps_git_bg=${BG_GIT_DIRTY}
      fi

      # Add the branch
      ps_git+="%K{${BG_TERM}}%F{${bg_branch}}${trans}"
      ps_git+="%K{${bg_branch}}%F{${fg_branch}}${branch_sym}${branch}%f %k"
      ps_git_len+=$((${trans_len} + ${branch_sym_len} + ${#branch} + 1))

      # A clean branch will have stats if is ahead or behind. A dirty branch
      # may not have stats if there are changes we didn't check for, i.e.,
      # total > 0 and stats = ''.
      if [[ -n "${ps_git_stats}" ]]; then
        ps_git+="%K{${bg_branch}}%F{${BG_GIT_STATS}}${trans}%f"
        ps_git+="%K{${BG_GIT_STATS}}${ps_git_stats} %k"
        ps_git_len+=$((${trans_len} + ${ps_git_stats_len} + 1))
      fi
    fi
  fi
}

# Print Prompt
# ------------

function precmd() {
  local -i last="$?"
  local user="$(print -nP '%n')"
  local sep='@'
  local host="$(print -nP '%m')"
  local dir="$(print -nP '%~')"
  local -i num_jobs="$(jobs | wc -l)"
  local -i fg_sym="${FG_SYM}"
  local last_ok
  local left_trans
  local trans
  local trans_2
  local branch_sym

  # User Powerline symbols
  if [[ -n "${POWERLINE}" ]]; then
    last_ok="${PS_PL_LAST_OK}"
    left_trans="${PS_PL_TRANS_LEFT}"
    trans="${PS_PL_TRANS}"
    trans_2="${PS_PL_TRANS_2}"
    branch_sym="${PS_PL_BRANCH_SYM}"

  # User regular symbols
  else
    last_ok="${PS_LAST_OK}"
    left_trans="${PS_TRANS_LEFT}"
    trans="${PS_TRANS}"
    trans_2="${PS_TRANS_2}"
    branch_sym="${PS_BRANCH_SYM}"
  fi

  # Print the second line of the right prompt
  RPROMPT=''

  # Show and highlight the shell level if not 1
  if [[ "${SHLVL}" -gt 1 ]]; then
    fg_sym="${FG_RIGHT_HL}"
    RPROMPT+="%F{${FG_RIGHT_HL}}${trans_2} L:${SHLVL} %f"
  fi

  # Show and highlight the number of jobs if not 0
  if [[ "${num_jobs}" -gt 0 ]]; then
    fg_sym="${FG_RIGHT_HL}"
    RPROMPT+="%F{${FG_RIGHT_HL}}${trans_2} J:${num_jobs} %f"
  fi

  RPROMPT+="%F{${FG_RIGHT}}${trans_2} %t %w %f"

  PS1=$'\n'

  # Print the first line of the left prompt
  ps_last_update "${last}" "${last_ok}"
  PS1+="${ps_last} %F{${FG_USER}}${user}%F{${FG_SEP}}${sep}"
  PS1+="%F{${FG_HOST}}${host} %F{${FG_DIR}}${dir}%f"

  # Print the first line of the right prompt
  ps_git_update "${trans}" "${branch_sym}"

  if [[ -n "${ps_git}" ]]; then
    local -i ps_left_len=$((${ps_last_len} + 1 + ${#user} + ${#sep} + ${#host} \
      + 1 + ${#dir}))
    local -i padding=$((${COLUMNS} - ${ps_left_len} - 1 - ${#left_trans} \
      - ${ps_git_len} - 1))

    if [[ "${padding}" -gt 0 ]]; then
      PS1+=" %F{${ps_git_bg}}${left_trans}"
      PS1+="%F{${FG_SYM}}${(l:$padding::-:)}%f${ps_git}"
    else
      PS1+=" ${ps_git}"
    fi
  fi

  # Print the newline at the end of the first line
  PS1+=$'\n'

  # Print the second line of the left prompt
  PS1+="%F{${fg_sym}}%#%f "
}

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

