_SCRIPTDIR=$(cd $(dirname $0);echo $PWD)

# Load grml zsh config
source /etc/zsh/zshrc

setopt PROMPT_SUBST

if [[ $(uname) == Linux ]]
then
	GIT_PROMPT_EXECUTABLE="haskell"
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
    RPROMPT="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $(git_super_status)"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Fix Ctrl+Shift+T
VTESCRIPT=/etc/profile.d/vte.sh
[[ -s $VTESCRIPT ]] && source $VTESCRIPT
