" First, go to https://github.com/junegunn/vim-plug
" and install Vim-Plug plugin manager
" Open vim and do :source %
" Lastly, do :PlugInstall

set nocompatible
set number
" set cursorline
set termguicolors

filetype on
filetype plugin on
filetype indent on

syntax on

set shiftwidth=4
set tabstop=4
set expandtab

set nobackup

set scrolloff=10
set nowrap

set incsearch
set ignorecase
set smartcase

set showcmd
set showmode
set showmatch

set hlsearch
set history=1000

set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

call plug#begin()

" List your plugins here
Plug 'tpope/vim-sensible'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }

call plug#end()

colorscheme catppuccin_mocha
