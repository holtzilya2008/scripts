syntax on
set modeline
set mouse=a
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set autoindent
set number

"For every buffer entering, highlight lines, that have length over 80
"characters
augroup vimrc_autocmds
    autocmd BufEnter * highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    autocmd BufEnter * match OverLength /\%80v.\+/
augroup END

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'kudabux/vim-srcery-drk'

Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-scripts/vim-airline'
Plugin 'vim-scripts/fugitive.vim'
Plugin 'bling/vim-bufferline'
Plugin 'edkolev/promptline.vim'

Plugin 'vim-scripts/cppcomplete'
Plugin 'vim-scripts/auto'
Plugin 'vim-scripts/STL-Syntax'
Plugin 'vim-scripts/AutoInclude'

Plugin 'vim-scripts/Emmet.vim'
Plugin 'vim-scripts/Sass'
Plugin 'vim-scripts/jsbeautify'

Bundle 'rkulla/pydiction'

call vundle#end()

"Airline plugin settings
set laststatus=2
let g:airline_theme = 'badwolf'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
"Bufferline plugin settings
let g:bufferline_solo_highlight = 1
"Pydiction plugin settings
let g:pydiction_location = '/home/$USER/.vim/bundle/pydiction/complete-dict'
let g:pydiction_menu_height = 3

filetype plugin indent on
filetype plugin on

colorscheme srcery-drk

