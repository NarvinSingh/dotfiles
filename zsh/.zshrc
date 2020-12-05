# Lines configured by zsh-newuser-install
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
declare -i FG_LDR="${CLR_GREY}"
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

# Git
# ---

# ## Init
declare git_path=$(which git)

if [[ "$?" -ne 0 ]]; then
  git_path=''
fi

# ## git_stat
git_stat() {
  local -r code="${1}" num_x="${2}" num_y="${3}"
  local res=''

  # Print a leading space, the code and the stats that are available.
  # The foreground color is set at the beginning and reset at the end of
  # the output. The background color is inherited. A trailing space should
  # be added and the background color should be reset after the last stat.
  if [[ "${num_x}" -gt 0 || "${num_y}" -gt 0 ]]; then
    res+=" %F{${FG_GIT_STATS}}${code}"

    if [[ "${num_x}" -gt 0 ]]; then res+="%F{${FG_GIT_STATS_X}}${num_x}"; fi

    if [[ "${num_y}" -gt 0 ]]; then
      res+="%F{${FG_GIT_STATS}}:%F{${FG_GIT_STATS_Y}}${num_y}"
    fi

    res+='%f'
  fi

  print -n "${res}"
}

# ## git_status
git_status() {
  local -r trans="${1}" branch_sym="${2}"

  # Git is installed
  if [[ -n "${git_path}" ]]; then
    local data

    # Assign the variable in a separate step from declaring it so we get
    # the correct last exit code
    data="$(${git_path} status --porcelain=v2 --branch 2> /dev/null)"

    # Inside a repo so generate and output the status
    if [[ "$?" -eq 0 ]]; then
      local branch ab
      local -i a b num_a num_mx num_my num_dx num_dy num_rx num_ry num_cx \
        num_cy num_um num_uax num_uay num_udx num_udy num_u total clr_branch
      local stats='' res='' is_clean=''

      # Parse the branch and fallback to a default value
      branch="${$(print -r "${data}" \
        | grep -m 1 '^# branch.head ' | cut -b 15-):-???}"

      # Parse the ahead and behind info
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
        stats+=" %F{${FG_GIT_STATS}}↑%F{${FG_GIT_STATS_X}}${a}%f"
      fi

      # Behind
      if [[ -n "${b}" && "${b}" -gt 0 ]]; then
        # But not ahead
        if [[ -z "${stats}" ]]; then stats+=' '; fi

        stats+="%F{${FG_GIT_S}}↓%F{${FG_GIT_STATS_X}}${b}%f"
      fi

      stats+=$(git_stat 'a' "${num_a}")
      stats+=$(git_stat 'm' "${num_mx}" "${num_my}")
      stats+=$(git_stat 'd' "${num_dx}" "${num_dy}")
      stats+=$(git_stat 'r' "${num_rx}" "${num_ry}")
      stats+=$(git_stat 'c' "${num_cx}" "${num_cy}")
      stats+=$(git_stat 'um' "${num_um}")
      stats+=$(git_stat 'ua' "${num_uax}" "${num_uay}")
      stats+=$(git_stat 'ud' "${num_udx}" "${num_udy}")
      stats+=$(git_stat '?' "${num_u}")

      # Construct the git portion of the prompt, which will vary depending
      # on whether or not the stats are empty

      # Clean branch
      if [[ "${total}" -eq 0 ]]; then
        is_clean=1
        fg_branch=${FG_GIT_CLEAN}
        bg_branch=${BG_GIT_CLEAN}

      # Dirty branch
      else
        is_clean=0
        fg_branch=${FG_GIT_DIRTY}
        bg_branch=${BG_GIT_DIRTY}
      fi

      # Add the branch
      res+="%K{${BG_TERM}}%F{${bg_branch}}${trans}"
      res+="%K{${bg_branch}}%F{${fg_branch}}${branch_sym}${branch}%f %k"

      # A clean branch will have stats if is ahead or behind. A dirty branch
      # may not have stats if there are changes we didn't check for, i.e.,
      # total > 0 and stats = ''.
      if [[ -n "${stats}" ]]; then
        res+="%K{${bg_branch}}%F{${BG_GIT_STATS}}${trans}%f"
        res+="%K{${BG_GIT_STATS}}${stats} %k"
      fi

      print "${res}\n${is_clean}"
    fi
  fi
}

# Print Prompt
# ------------

# ## print_len
print_len() {
  local -r str="$1"

  # Strip the color, bold, underline and standout codes from the string and
  # print its length
  print -n ${#${(S%%)str//\%([KF]\{*\}|[kfBUSbus])}}
}

# ## precmd
precmd() {
  # Get the last error code right away before another exit code overwrites it
  local -ri last="$?"
  local last_ok left_trans trans trans_2 branch_sym

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

  # Print the blank line between the end of the previous command and this prompt
  # TODO: Remove blank line when this is the first prompt on the screen
  PS1=$'\n'

  # Print the first line of the left prompt
  local l

  # Format the last exit code info based on the value we captured at the
  # beginning of the function
  if [[ "${last}" -eq 0 ]]; then l=$(print -n "%F{${FG_LAST_OK}}${last_ok}%f")
  else l=$(print -n "%F{${FG_LAST_ERR}}${last}%f"); fi

  PS1+="${l} %F{${FG_USER}}%n%F{${FG_SEP}}@%F{${FG_HOST}}%m %F{${FG_DIR}}%~%f"

  # Print the first line of the right prompt
  local g is_clean

  {
    read -r g
    read -r is_clean
  } < <(git_status "${trans}" "${branch_sym}")

  # Only print this part of the prompt if there is a git status
  if [[ -n "${g}" ]]; then
    # padding = the total columns
    # - the printable length of PS1
    # + 1 for the newline at the beginning of PS1 which shouldn't be counted
    #   as part of the length of PS1
    # - 1 for the space after PS1
    # - the length of the left transition
    # - the printable length of the git status
    # - 1 for a right margin
    local -i padding=$((${COLUMNS} - $(print_len "${PS1}") + 1 - 1 \
      - ${#left_trans} - $(print_len "${g}") - 1))

    if [[ "${padding}" -gt 0 ]]; then
      if [[ "${is_clean}" -eq 1 ]]; then trans_fg="${BG_GIT_CLEAN}"
      else trans_fg="${BG_GIT_DIRTY}"; fi

      PS1+=" %F{${trans_fg}}${left_trans}"
      PS1+="%F{${FG_LDR}}${(l:$padding::-:)}%f${g}"
    else
      PS1+=" ${g}"
    fi
  fi

  # Print the newline at the end of the first line
  PS1+=$'\n'

  # Print the second line of the left prompt and highlight if if the second
  # line of the right prompt would have any highlights
  PS1+="%F{${FG_SYM}}%(1j.%F{${FG_RIGHT_HL}}.)%(2L.%F{${FG_RIGHT_HL}}.)%#%f "

  # Print the second line of the right prompt along with any highlights
  RPROMPT=''
  # Show and highlight the number of jobs if not 0
  RPROMPT+="%(1j.%F{${FG_RIGHT_HL}}${trans_2} J:%j %f.)"
  # Show and highlight the shell level if not 1
  RPROMPT+="%(2L.%F{${FG_RIGHT_HL}}${trans_2} L:%L %f.)"
  RPROMPT+="%F{${FG_RIGHT}}${trans_2} %t %w %f"
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

