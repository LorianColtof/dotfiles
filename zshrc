_SCRIPTDIR=$(cd $(dirname $0);echo $PWD)

# Load grml zsh config
source /etc/zsh/zshrc

setopt PROMPT_SUBST

if [[ $(uname) == Linux ]]
then
	if ! uname -r | grep Microsoft > /dev/null
	then
		GIT_PROMPT_EXECUTABLE="haskell"
	fi
	source $_SCRIPTDIR/zsh-git-prompt/zshrc.sh
fi

zstyle ':prompt:grml:right:setup' use-rprompt false

# Vi mode
bindkey -v

setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

zstyle ':completion:*' menu select

export PATH=$PATH:/home/lorian/.gem/ruby/2.3.0/bin/

source $_SCRIPTDIR/aliases
source $_SCRIPTDIR/env

setopt NO_HUP

source $_SCRIPTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
if [ $TERM != "linux" ]
then
    source $_SCRIPTDIR/agnoster-zsh-theme/agnoster.zsh-theme
fi

# Expand autocompletion with Ctrl+F
bindkey '^F' forward-char

# Make backspace work after entering Vi insert mode
bindkey -v '^?' backward-delete-char

# Remove ESC timeout
export KEYTIMEOUT=1

bindkey '^P' up-history
bindkey '^N' down-history

bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% N]% %{$reset_color%}"
    if [[ $(uname) == Linux ]]; then
        RPROMPT="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $(git_super_status)"
    else
        RPROMPT="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"
    fi
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

export LS_COLORS='ow=01;36;40'

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
                        "${AGNOSTER_PROMPT_SEGMENTS[@]:3}")

function custom_prompt_virtualenv() {
  if [[ -n $VIRTUAL_ENV ]]; then
    color=cyan
    prompt_segment $color $PRIMARY_FG
    print -Pn " $(basename $VIRTUAL_ENV | sed 's/.\+_\([^_]\+\)/\1/') "
  fi
}

# Fix Ctrl+Shift+T
VTESCRIPT=/etc/profile.d/vte.sh
[[ -s $VTESCRIPT ]] && source $VTESCRIPT
