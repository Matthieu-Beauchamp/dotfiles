""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map <leader> to space
let mapleader = " "

" Quick ESC
imap jk <Esc>

" Move in insert mode
" <C-h> is broken, same as in normal mode
imap <C-h> <Left>
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-l> <Right>


imap <C-w> <C-o>w
imap <C-b> <C-o>b
imap <C-e> <C-o>e

" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk

" I like using H and L for beginning/end of line
nmap H ^
nmap L $

" Fast scroll
nmap J 5j
nmap K 5k

" Use leader to join lines (was J)
nmap <leader>j :j<cr>

" Split movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" <C-h> is broken in neovim with certain terminals, puts <BS> instead of ^H
" This can be checked in insert mode with <C-v><C-h>
nnoremap <BS> <C-w>h

" Tabs handling
nmap <leader>tt :tabnew
nmap <leader>tn :tabn<cr>
nmap <leader>tp :tabp<cr>
nmap <leader>to :tabo<cr>

" Remove highlights from search (clear search)
nmap <leader>h :set hlsearch!<cr>
" nmap <leader>h :nohlsearch<cr>

" Quick commands
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

