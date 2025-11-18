# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="half-life"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR="nvim"

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

source <(fzf --zsh)

# ZSH History
HISTFILE=~/.zhistory
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
command_not_found_handler() {
	printf "%s%s? I don't know what it is\n" "$acc" "$0" >&2
    return 127
}

# Alias

alias c="clear"
alias cat="bat --theme=base16"
alias l="ls -CF"
alias ls="ls --color=auto"
alias ll="ls -alF"
alias la="ls -A"
alias lla="ll --color -h --group-directories-first"

alias dirsize="du -sh"
alias grep="grep --color=auto"
alias fcfv="fc-cache -fv"
alias snvim="sudo -E -s nvim"

alias pminfo="yay -Si"
alias pmi="sudo pacman -S"
alias pmu="sudo pacman -R"
alias pml="yay -Q"
alias pmc="du -hd1 /var/cache/pacman"
alias yayc="du -hd1 ~/.cache/yay"
alias pmclean="yay -Scc"
alias pmconf="sudo -E -s nvim /etc/pacman.conf"

alias gaa="git add ."
alias gcms="git commit -m"
alias gsmu="git pull --recurse-submodules; git submodule update --remote --merge"

# WiFi
alias wfget="iwctl station wlan0 get-networks"

wfcon() {
    read -r "wifi_name?Enter WiFi name: "
    iwctl station wlan0 connect "$wifi_name" --passphrase --ask
}
