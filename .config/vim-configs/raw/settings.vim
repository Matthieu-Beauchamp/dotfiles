" Restrict to Vim only
set nocompatible

" Yank to system clipboard
" For VSCodeVim, ensure "Use system clipboard" is checked.
" set clipboard=unnamedplus
if has('unix')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

" Enable syntax highlighting
syntax enable

" Enable status bar, if powerline is installed, it will take effect.
set laststatus=2

set encoding=utf-8

"Enable text wrap
set wrap

" Set hybrid line numbers, use `set number` for absolute
set number relativenumber

" Tab width to 4 spaces
set ts=4 sw=4 expandtab

" Show blanks
" set list
" set listchars=tab:-->,space:,multispace:
" set nolist

" Column delimiter
set colorcolumn=80,120
set textwidth=119

" Keep indentation level for new lines
set autoindent

" Needed to see <leader> timeout
set showcmd

" Highlight search results
set hlsearch


set timeoutlen=400

