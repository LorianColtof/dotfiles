export _CONFIGDIR=~/.config/zsh-dotfiles

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

ZSH_CUSTOM="$_CONFIGDIR/oh-my-zsh-custom"

ZSH_DISABLE_COMPFIX="true"

alias zshreload="exec zsh"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    sudo
    vi-mode
    git
    zsh-autosuggestions
    fzf
    dirhistory
    gitignore
    zsh-interactive-cd
    kube-ps1)

if [[ $(uname) == Linux ]]; then
    GIT_PROMPT_EXECUTABLE="haskell"

    plugins+=(git-prompt)

    # Make sure that the submodule can be used as a oh-my-zsh plugin
    pushd $_CONFIGDIR/oh-my-zsh-custom/plugins/git-prompt/ >/dev/null
    if [ ! -f git-prompt.plugin.zsh ]; then
        ln -s zshrc.sh git-prompt.plugin.zsh
    fi
    popd >/dev/null
fi

source $ZSH/oh-my-zsh.sh

setopt PROMPT_SUBST
setopt NO_HUP
setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

zstyle ':completion:*' menu select

source $_CONFIGDIR/aliases
source $_CONFIGDIR/env

# Expand autocompletion with Ctrl+F
bindkey '^F' forward-char

bindkey '^S' sudo-command-line

# Remove ESC timeout
export KEYTIMEOUT=1

ENABLE_KUBE_PS1=false

function zle-line-init zle-keymap-select {
    RPROMPT="${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
    if [[ $(uname) == Linux ]]; then
         RPROMPT="$RPROMPT $(git_super_status)"
    fi

    if $ENABLE_KUBE_PS1; then
      RPROMPT="$RPROMPT $(kube_ps1)"
    fi
    zle reset-prompt
}

# Toggle command
function kpr {
  if $ENABLE_KUBE_PS1; then
    ENABLE_KUBE_PS1=false
  else
    ENABLE_KUBE_PS1=true
  fi
}

zle -N zle-line-init
zle -N zle-keymap-select

zstyle ':vcs_info:git*+set-message:*' hooks git-abbrev

function +vi-git-abbrev() {
    MAX_BRANCH_LEN=30
    branch=${hook_com[branch]}

    if [[ ${#branch} -ge $MAX_BRANCH_LEN ]]; then
        branch="${branch:0:$MAX_BRANCH_LEN}…"
    fi

    hook_com[branch]=$branch
}

AGNOSTER_PROMPT_SEGMENTS=("${AGNOSTER_PROMPT_SEGMENTS[@]:0:2}" \
                        "custom_prompt_virtualenv" \
                        "${AGNOSTER_PROMPT_SEGMENTS[4]}" \
                        "custom_prompt_git" \
                        "${AGNOSTER_PROMPT_SEGMENTS[@]:5}" \
                    )

function custom_prompt_virtualenv() {
  if [[ -n $VIRTUAL_ENV ]]; then
    color=cyan
    prompt_segment $color $PRIMARY_FG
    print -Pn " $(basename $VIRTUAL_ENV | sed 's/.\+_\([^_]\+\)/\1/') "
  fi
}


function custom_prompt_git() {
  local color ref

  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules | head -n1)"
  }

  ref="$vcs_info_msg_0_"

  if [[ -n "$ref" ]]; then
    if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = "true" ]]; then
      color=yellow
      ref="${ref} $GEAR"
    elif is_dirty; then
      color=yellow
      ref="${ref} $PLUSMINUS"
    else
      color=green
      ref="${ref} "
    fi
    if [[ "${ref/.../}" == "$ref" ]]; then
      ref="$BRANCH $ref"
    else
      ref="$DETACHED ${ref/.../}"
    fi
    prompt_segment $color $PRIMARY_FG
    print -n " $ref"
  fi
}

# Fix Ctrl+Shift+T
VTESCRIPT=/etc/profile.d/vte.sh
[[ ! -s $VTESCRIPT ]] || source $VTESCRIPT