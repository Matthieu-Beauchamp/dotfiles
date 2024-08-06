"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

   Plug 'dracula/vim', { 'as': 'dracula' }

   Plug 'tpope/vim-surround'

   Plug 'vim-airline/vim-airline'
   Plug 'vim-airline/vim-airline-themes'

   " Both of these integrate automatically with airline.
   Plug 'tpope/vim-fugitive' " Git integration, use :Git <cmd...>
   Plug 'airblade/vim-gitgutter' " Gives hunks count and side bar

   Plug 'ryanoasis/vim-devicons' " Must be loaded last

call plug#end()

colorscheme dracula


" Airline ---------------------------------------------------------------------

" TODO: customize line contents
let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled = 0

" A lot of work is needed to get colored hunks
function! GetGitHunk(index, symbol)
    let hunks = GitGutterGetHunkSummary()
    let hunk = hunks[a:index]
    if hunk != 0
        let txt = printf('%s%d', a:symbol, hunk)
        return a:index == 2 ? txt : txt . ' '
    endif

    return ''
endfunction

function! GitAdded()
    return GetGitHunk(0, '+')
endfunction

function! GitModified()
    return GetGitHunk(1, '~')
endfunction

function! GitRemoved()
    return GetGitHunk(2, '-')
endfunction

call airline#parts#define_function('hunksA', 'GitAdded')
call airline#parts#define_function('hunksM', 'GitModified')
call airline#parts#define_function('hunksR', 'GitRemoved')

call airline#parts#define_accent('hunksA', 'green')
call airline#parts#define_accent('hunksM', 'yellow')
call airline#parts#define_accent('hunksR', 'red')

" Using the 'branch' part directly does not work for some reason.
function! GetGitBranch()
    return airline#extensions#branch#get_head()
endfunction

call airline#parts#define_function('my_branch', 'GetGitBranch')

let g:airline_section_b = airline#section#create(['my_branch', 'hunksA', 'hunksM', 'hunksR'])

let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#coc#error_symbol = ''
let g:airline#extensions#coc#warning_symbol = ''
let g:airline#extensions#coc#show_coc_status = 1

function! Location()
    let curLine = line('.')
    let maxLines = line('$')
    let col = col('.')
    return printf('%d:%d (%d)', curLine, col, maxLines)
    " return printf(' %d:%d', curLine, col)
endfunction

let g:airline_section_z = '%{Location()}'


" See :AirlineTheme <theme>
" let g:airline_theme='deus'
let g:airline_theme='dracula'

