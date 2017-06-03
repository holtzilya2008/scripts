syntax on
set modeline
set mouse=a
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set autoindent
set background=dark
set textwidth=80

augroup vimrc_autocmds
    autocmd BufEnter * highlight ColorColumn ctermbg=red ctermfg=white guibg=#592929
    autocmd BufEnter * match ColorColumn /\%>80v.\+/
augroup END

