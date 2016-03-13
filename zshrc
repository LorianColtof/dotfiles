_SCRIPTDIR=$(cd $(dirname $0);echo $PWD)

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-default.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

GIT_PROMPT_EXECUTABLE="haskell"
source /home/lorian/Dropbox/zsh-git-prompt/zshrc.sh

# Set up the prompt
RPROMPT='$(git_super_status)' # '%F{blue}[$(date +"%d-%m-%Y-%T")]'

export EDITOR=vim
bindkey -v
export KEYTIMEOUT=1

function precmd () {
	print -Pn "\e]2;%n@%M | %~\a"
}

autoload -Uz promptinit
promptinit
if [[ $EUID -eq 0 ]]; then
	prompt adam1 red
else
	prompt adam1
fi


setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history


# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' menu select

source $_SCRIPTDIR/aliases
source $_SCRIPTDIR/env

alias loadrc="source ~/.zshrc"

setopt NO_HUP

source $_SCRIPTDIR/agnoster.zsh-theme
source /etc/profile.d/vte.sh
