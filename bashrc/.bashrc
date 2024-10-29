#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.sssh

alias cat="bat --theme=base16"
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# ALIAS
alias c='clear'
alias msk='musikcube'
alias pmc='du -hd1 /var/cache/pacman'
alias pminfo='yay -Si'
alias pmi='sudo pacman -S'
alias pmu='sudo pacman -R'
alias pmclean='yay -Scc'
alias pmconf='sudo nvim /etc/pacman.conf'
alias fcfv='fc-cache -fv'

alias warpc='warp-cli connect'
alias warpdc='warp-cli disconnect'
alias warpm='warp-cli mode warp+doh'
alias warpch='curl https://www.cloudflare.com/cdn-cgi/trace/'

alias gaa='git add .'
alias gcm='git commit -m'

export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export PATH="$PATH:$HOME/.local/bin"

export PATH="$HOME/.rbenv/shims:$PATH"
eval "$(rbenv init -)"

eval $(thefuck --alias)

export PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH="/usr/share/pkgconfig:$PKG_CONFIG_PATH"
. "$HOME/.cargo/env"

gitoken ()
{
    git clone https://$PAT@github.com/$GHA/"$1".git
}


