export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

if [ -n "$WSL_DISTRO_NAME" ]; then
    export PATH="/mnt/c/Users/$USER/AppData/Local/Programs/Microsoft VS Code/bin":$PATH
fi

if [[ -f ~/.secrets ]]; then
    source ~/.secrets
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="half-life"

# export MANPATH="/usr/local/man:$MANPATH"
export MANPAGER="nvim +Man!"

# Manually set language environment
# export LANG=en_US.UTF-8

export EDITOR="nvim"
export VISUAL="nvim"

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"

source <(fzf --zsh)

if [ -d "$HOME/scripts" ] ;
    then PATH="$HOME/scripts:$PATH"
fi

# ZSH History
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ZSH Options
setopt AUTOCD              # change directory just by typing its name
setopt PROMPT_SUBST        # enable command substitution in prompt
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED		   # The completion menu takes less space.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Command not found
source ~/.zsh/_command_not_found_handler

# Alias
source ~/.zsh/_alias

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/moonbrooke/.lmstudio/bin"
# End of LM Studio CLI section

eval "$(/home/moonbrooke/.local/bin/mise activate zsh)" # added by https://mise.run/zsh

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# opencode
export PATH=/home/moonbrooke/.opencode/bin:$PATH

# Pi
export PATH="/home/moonbrooke/.local/share/mise/installs/node/26.9.0/bin:$PATH"
