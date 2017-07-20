_SCRIPTDIR=$(cd $(dirname $0);echo $PWD)

# Load grml zsh config
source /etc/zsh/zshrc

setopt PROMPT_SUBST

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-default-dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

alias makelight="source $HOME/.config/base16-shell/scripts/base16-default-light.sh "
alias makedark="source $HOME/.config/base16-shell/scripts/base16-default-dark.sh "


if [[ $(uname) == Linux ]]
then
	GIT_PROMPT_EXECUTABLE="haskell"
	source $_SCRIPTDIR/zsh-git-prompt/zshrc.sh
	# Set up the prompt
	RPROMPT='$(git_super_status)'
fi

zstyle ':prompt:grml:right:setup' use-rprompt false

bindkey -v

function precmd () {
    print -Pn "\e]2;%n@%M | %~\a"
}


setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

zstyle ':completion:*' menu select

export PATH=$PATH:/home/lorian/.gem/ruby/2.3.0/bin/

source $_SCRIPTDIR/aliases
source $_SCRIPTDIR/env

alias loadrc="source ~/.zshrc"

setopt NO_HUP

source $_SCRIPTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh
if [ $TERM != "linux" ]
then
    source $_SCRIPTDIR/agnoster-zsh-theme/agnoster.zsh-theme

fi

VTESCRIPT=/etc/profile.d/vte.sh
[[ -s $VTESCRIPT ]] && source $VTESCRIPT
