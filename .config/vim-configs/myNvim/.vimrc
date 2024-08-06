" Restrict to Vim only
set nocompatible

" Yank to system clipboard
" For VSCodeVim, ensure "Use system clipboard" is checked.
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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" map <leader> to space with timeout of 750ms (default "\" and 1000ms)
let mapleader = " "

" Quick ESC
imap jk <ESC>

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
" <C-h> is broken in neovim with certain terminals, it send <BS> instead
" This can be checked in insert mode with <C-v><C-h>
nnoremap <BS> <C-w>h

" Tabs handling
nmap <leader>tt :tabnew
nmap <leader>tn :tabn<cr>
nmap <leader>tp :tabp<cr>
nmap <leader>to :tabo<cr>

" Remove highlights from search (clear search)
nmap <leader>/ :noh<cr>

" Quick commands
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>

" NERDTree
let NERDTreeMapActivateNode = 'l'
let NERDTreeMapCloseDir = 'h'

nnoremap <C-t> :NERDTreeToggle<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGINS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

    Plug 'dracula/vim', { 'as': 'dracula' }

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " Both of these integrate automatically with airline.
    Plug 'tpope/vim-fugitive' " Git integration, use :Git <cmd...>
    Plug 'airblade/vim-gitgutter' " Gives hunks count and side bar

    Plug 'preservim/nerdtree'

    Plug 'scrooloose/nerdcommenter'

    Plug 'nvim-telescope/telescope.nvim'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-lua/plenary.nvim'

    Plug 'lukas-reineke/indent-blankline.nvim'

    " TODO: Configure colors?
    Plug 'HiPhish/rainbow-delimiters.nvim'

    Plug 'vim-autoformat/vim-autoformat'

    Plug 'nvimdev/dashboard-nvim'

    Plug 'mfussenegger/nvim-dap'
    Plug 'theHamsta/nvim-dap-virtual-text'
    Plug 'mxsdev/nvim-dap-vscode-js'
    Plug 'rcarriga/nvim-dap-ui' " TODO: Not configured

    Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}

    Plug 'nvim-tree/nvim-web-devicons'
    Plug 'ryanoasis/vim-devicons' " Must be loaded last

call plug#end()

colorscheme dracula


" Airline ---------------------------------------------------------------------

" TODO: customize line contents
let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled = 1

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
    " let maxLines = line('$')
    let col = col('.')
    " return printf('%d:%d | %d', curLine, col, maxLines)
    return printf(' %d:%d', curLine, col)
endfunction

let g:airline_section_z = '%{Location()}'


" See :AirlineTheme <theme>
let g:airline_theme='deus'
" let g:airline_theme='dracula'


" NERDCommenter ---------------------------------------------------------------
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1

nnoremap <leader>c <plug>NERDCommenterToggle
vnoremap <leader>c <plug>NERDCommenterToggle
nnoremap <leader>ca <plug>NERDCommenterAppend


" Telescope -------------------------------------------------------------------
" TODO: find files not searching hidden files
" TODO: Search in tree sitter..?
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


" Indent blankline ------------------------------------------------------------
" TODO: Multiple guide colors, see README (what about rainbow delimiters?)
if has('nvim')
lua require("ibl").setup()


" Tree sitter -----------------------------------------------------------------
lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    auto_install = true,
    highlight = {
        enable=true
    },
}
EOF


" Dashboard -------------------------------------------------------------------
lua << EOF
-- TODO: customize
require('dashboard').setup {
        theme = 'hyper',
        config = {
          week_header = {
           enable = true,
          },
          shortcut = {
            { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Files',
              group = 'Label',
              action = 'Telescope find_files',
              key = 'f',
            },
            {
              desc = ' Apps',
              group = 'DiagnosticHint',
              action = 'Telescope app',
              key = 'a',
            },
            {
              desc = ' dotfiles',
              group = 'Number',
              action = 'Telescope dotfiles',
              key = 'd',
            },
          },
        },
      }
EOF


" nvim-dap (Debugging) --------------------------------------------------------
" See :h dap.txt and 
" https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python
lua << EOF
local dap = require('dap')

-- Python
dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = vim.fn.expand('~/.virtualenvs/debugpy/bin/python'),
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
    console = "externalTerminal";
    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end;
  },
}


-- C/C++/Rust
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
  },
}


-- JS 
require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  debugger_path = vim.fn.expand("~/.vim/plugged/vscode-js-debug"), -- Must be manually installed 
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

for _, language in ipairs({ "typescript", "javascript" }) do
  require("dap").configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/jest/bin/jest.js",
        "--runInBand",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    }
  }
end


-- Overwrites dap.configurations.* for given configurations
-- dap.adapter.* must still be present for 
require('dap.ext.vscode').load_launchjs(nil, { 
    cppdbg = {'c', 'cpp'} 
})


dap.defaults.fallback.exception_breakpoints = {'uncaught'}

vim.keymap.set('n', '<C-c>', function() dap.continue() end)
vim.keymap.set('n', '<C-Right>', function() dap.step_over() end)
vim.keymap.set('n', '<C-Down>', function() dap.step_into() end)
vim.keymap.set('n', '<C-Up>', function() dap.step_out() end)

vim.keymap.set('n', '<leader>dr', function() dap.restart() end)
vim.keymap.set('n', '<leader>dl', function() dap.run_last() end)
vim.keymap.set('n', '<leader>dt', function() dap.terminate() end)

vim.keymap.set('n', '<leader>db', function() dap.list_breakpoitns() end)
vim.keymap.set('n', '<leader>dc', function() dap.clear_breakpoitns() end)

vim.keymap.set('n', '<C-Left>', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<C-S-Left>', function() dap.toggle_breakpoint(nil, nil, vim.fn.input('Log message: ')) end)

vim.keymap.set({'n', 'v'}, '<leader>dh', function() require('dap.ui.widgets').hover() end)
vim.keymap.set({'n', 'v'}, '<leader>dp', function() require('dap.ui.widgets').preview() end)

vim.keymap.set('n', '<leader>dd', function() require('dapui').toggle() end)

vim.keymap.set('n', '<leader>ds', function() 
    local widgets = require('dap.ui.widgets')
    widgets.sidebar(widgets.scopes).open()
end)

vim.keymap.set('n', '<leader>df', function() 
    local widgets = require('dap.ui.widgets')
    widgets.sidebar(widgets.frames).open()
end)

-- TODO: Still missing some keybinds, but this should be good enough,
-- check :h dap.txt for all fetures

-- Set up terminal for programs (otherwise we have no output...)
dap.defaults.fallback.external_terminal = {
    command = 'qterminal';
    args = {'-e'};
}
dap.defaults.fallback.force_external_terminal = true


-- Dap UI ---------------------------------------------------------------------
require('dapui').setup()

EOF



" Virtual text ----------------------------------------------------------------
lua require("nvim-dap-virtual-text").setup()

endif

sign define DapBreakpoint text= texthl=Error 
sign define DapBreakpointCondition text= texthl=Error 
sign define DapStopped text= texthl=CursorLineNr linehl=CursorLine

" Conquer of Completion -------------------------------------------------------
let g:coc_global_extensions = [
            \'coc-json',
            \'coc-vimlsp',
            \'coc-clangd',
            \'coc-sh',
            \'coc-markdownlint',
            \'coc-css',
            \'coc-html',
            \'coc-pyright',
            \'coc-eslint',
            \'coc-lua',
            \'coc-cmake',
            \'coc-texlab',
            \'coc-html-css-support',
            \'coc-jest',
            \'coc-tsserver',
            \'coc-spell-checker', 
            \]

" Too annoying since it opens a window
" autocmd VimEnter * CocUpdate

" Taken from the docs
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes

inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1) :
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()

inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" TODO: m is slow, find a good key on left hand
" use m instead, we use K for fast scroll
" Use K to show documentation in preview window
nnoremap m :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('m', 'in')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" We use Autoformat instead (={motion}).
" Formatting selected code
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" TODO: conflict with <space>c for commenting lines, plus i have no idea what are those
" Mappings for CoCList
" Show all diagnostics
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" May move the plug segment to its own file if it gets big
"
" if filereadable(expand("~/.vimrc.plug"))
"	source ~/.vimrc.plug
" endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" THEME
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://vimhelp.org/syntax.txt.html#highlight-ctermfg
" Assuming default color palette (NR-8 codes):
" 0 -> black       0* -> darkgrey
" 1 -> darkred     1* -> red
" 2 -> darkgreen   2* -> green
" 3 -> darkyellow  3* -> yellow
" 4 -> darkblue    4* -> blue
" 5 -> darkmagenta 5* -> magenta
" 6 -> darkcyan    6* -> cyan
" 7 -> grey        7* -> white

" highlight ColorColumn ctermbg=grey

" TODO: Cursor gets hidden when in whitespace
" set cursorline

" highlight CursorLine cterm=NONE ctermbg=darkgrey
"
" highlight Visual ctermbg=grey
"
" highlight LineNr ctermfg=darkgrey ctermbg=black
" highlight CursorLineNr ctermfg=grey
" highlight! link CursorLineNr CursorLine

" highlight! Whitespace ctermfg=grey

