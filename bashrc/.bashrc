#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.sssh

export FLATPAK_DIR='/var/lib/flatpak/app/'

# ALIAS
alias cat="bat --theme=base16"
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias lla='ll --color -h --group-directories-first'

alias c='clear'
alias msk='musikcube'
alias pmc='du -hd1 /var/cache/pacman'
alias pminfo='yay -Si'
alias pmi='sudo pacman -S'
alias pmu='sudo pacman -R'
alias pmclean='yay -Scc'
alias pmconf='sudo -E -s nvim /etc/pacman.conf'
alias fcfv='fc-cache -fv'
alias stowall='cd ~/dotfiles/ && stow */'
alias unstow='stow -D'
alias yayc='du -hd1 ~/.cache/yay'
alias flatpakdir='cd $FLATPAK_DIR'

alias warpc='warp-cli connect'
alias warpdc='warp-cli disconnect'
alias warpm='warp-cli mode warp+doh'
alias warpch='curl https://www.cloudflare.com/cdn-cgi/trace/'

alias gaa='git add .'
alias gcm='git commit -m'

alias ytmp3='yt-dlp -f bestaudio --extract-audio --audio-format mp3 -o "~/Downloads/%(title)s.%(ext)s"'
alias ytbest='yt-dlp -o "~/Downloads/%(title)s.%(ext)s"'
alias yt720='yt-dlp -S "height:720" -o "~/Downloads/%(title)s.%(ext)s"'
alias yt480='yt-dlp -S "height:480" -o "~/Downloads/%(title)s.%(ext)s"'

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


