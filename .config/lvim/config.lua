-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.cmd("source ~/.config/vim-configs/raw/settings.vim")

lvim.plugins = {
    { "Mofiqul/dracula.nvim" },
    -- Configure LazyVim to load dracula
    -- {
    --     "LazyVim/LazyVim",
    --     opts = {
    --         colorscheme = "dracula",
    --     },
    -- },
    {
        "navarasu/onedark.nvim",
        config = function()
            SetupOneDark()
        end
    },
    -- { "lunarvim/colorschemes" },
    { "tpope/vim-surround" },
--    { "nvim-treesitter/nvim-treesitter-angular" },
    { "mxsdev/nvim-dap-vscode-js" },
--    {
--        "microsoft/vscode-js-debug",
--        lazy = true,
--        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
--    },
    -- All CMake plugins create files in directory...
    -- TODO: This one looks better: https://github.com/Civitasv/cmake-tools.nvim/blob/master/docs/basic_usage.md
    -- => Take the best of both worlds and build our own,
    --      also need ot be able to set the workspace directory
    -- { "cdelledonne/vim-cmake" },
    { "Matthieu-Beauchamp/vim-cmake" },
    { "p00f/clangd_extensions.nvim" }, -- TODO: Setup, Keymap
}


-- In case we pay for it, it will be there
-- table.insert(lvim.plugins, {
--   "zbirenbaum/copilot-cmp",
--   event = "InsertEnter",
--   dependencies = { "zbirenbaum/copilot.lua" },
--   config = function()
--     vim.defer_fn(function()
--       require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
--       require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
--     end, 100)
--   end,
-- })

-------------------------------------------------------------------------------
-- Theme
-------------------------------------------------------------------------------
-- https://github.com/LunarVim/LunarVim/discussions/2829

function SetupOneDark()
    require('onedark').setup {
        -- Main options --
        style = 'darker',             -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
        transparent = false,          -- Show/hide background
        term_colors = false,          -- Change terminal color as per the selected theme style
        ending_tildes = false,        -- Show the end-of-buffer tildes. By default they are hidden
        cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

        -- toggle theme style ---
        toggle_style_key = "<leader>qq", --"<leader>ts", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"

        -- { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }
        toggle_style_list = { 'darker', 'warm', 'light' }, -- List of styles to toggle between

        -- Changecode style ---
        -- Options are italic, bold, underline, none
        -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
        code_style = {
            comments = 'italic',
            keywords = 'italic',
            functions = 'none',
            strings = 'none',
            variables = 'none'
        },

        -- Lualine options --
        lualine = {
            transparent = false, -- lualine center bar transparency
        },

        -- Custom Highlights --
        colors = {},     -- Override default colors
        highlights = {}, -- Override highlight groups

        -- Plugins Config --
        diagnostics = {
            darker = true,     -- darker colors for diagnostic
            undercurl = true,  -- use undercurl instead of underline for diagnostics
            background = true, -- use background color for virtual text
        },
    }

    -- https://github.com/LunarVim/LunarVim/issues/3170
    -- Autocommands (https://neovim.io/doc/user/autocmd.html)
    -- Use :Inspect to get color group of symbol under cursor
    vim.cmd [[au ColorScheme * hi! link @type.builtin Keyword]]
    vim.cmd [[au ColorScheme * hi! link @type.qualifier.cpp Keyword]]
end

-- Enable
SetupOneDark()
require('onedark').load()

-- lvim.colorscheme = "tokyonight-moon"
-- lvim.colorscheme = "dracula"
lvim.colorscheme = "onedark"

lvim.builtin.nvimtree.setup.renderer.indent_markers.enable = true
lvim.builtin.nvimtree.setup.renderer.icons.show.folder_arrow = false
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.folder.arrow_closed = ''
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.folder.arrow_open = ''

-------------------------------------------------------------------------------
-- PLUGIN OVERRIDE
-------------------------------------------------------------------------------

lvim.builtin.telescope.defaults.path_display = { "absolute" }

-------------------------------------------------------------------------------
-- BUGS
-------------------------------------------------------------------------------

-- Indents too much (one more)
lvim.builtin.treesitter.indent = {
    disable = { "cpp" }
}

-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------

require("lvim.lsp.manager").setup("angularls")

-- https://www.lunarvim.org/docs/configuration/language-features/linting-and-formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
    { name = "prettier", },
    { name = "latexindent" }
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
    { name = "eslint_d" },
}



-- -------------------------------------------------------------------------------
-- -- Tasks
-- -------------------------------------------------------------------------------

-- local Path = require('plenary.path')
-- require('tasks').setup({
--     -- Default module parameters with which `neovim.json` will be created.
--     default_params = {
--         cmake = {
--             -- CMake executable to use, can be changed using `:Task set_module_param cmake cmd`.
--             cmd = 'cmake',
--             -- Build directory. The expressions `{cwd}`, `{os}` and `{build_type}`
--             -- will be expanded with the corresponding text values. Could be a function that return the path to the build directory.
--             build_dir = tostring(Path:new('{cwd}', 'build', '{os}-{build_type}')),
--             build_type = 'Debug', -- Build type, can be changed using `:Task set_module_param cmake build_type`.
--             -- DAP configuration name from `require('dap').configurations`.
--             -- If there is no such configuration, a new one with this name as
--             -- `type` will be created.
--             dap_name = 'cppdbg',
--             args = { -- Task default arguments.
--                 configure = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1', '-G', 'Ninja' },
--             },
--         },
--     },
--     save_before_run = true,      -- If true, all files will be saved before executing a task.
--     params_file = 'neovim.json', -- JSON file to store module and task parameters.
--     quickfix = {
--         pos = 'botright',        -- Default quickfix position.
--         height = 12,             -- Default height.
--     },
--     -- Command to run after starting DAP session. You can set it to `false` if
--     -- you don't want to open anything or `require('dapui').open` if you are
--     -- using https://github.com/rcarriga/nvim-dap-ui
--     dap_open_command = function() return require('dap-ui').open() end,
-- })


-------------------------------------------------------------------------------
-- Mappings
-------------------------------------------------------------------------------

lvim.leader = "space"

-- Must remove lsp bindings first
lvim.lsp.buffer_mappings.normal_mode['M'] = nil
lvim.lsp.buffer_mappings.normal_mode['M'] = lvim.lsp.buffer_mappings.normal_mode['K']
lvim.lsp.buffer_mappings.normal_mode['K'] = nil

vim.cmd("source ~/.config/vim-configs/raw/keymaps.vim")
-- vim.cmd("nunmap <leader>/") -- use <leader>h instead to remove search highlights

lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.size = function(term)
    if term.direction == "horizontal" then
        return vim.o.lines * 0.25
    elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
    end
end

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- LunarVim mappings overview -------------------------------------------------
-- gx to open link under cursor!
-- General vim: https://devhints.io/vim
-- LunarVim:    https://www.lunarvim.org/docs/beginners-guide/keybinds-overview

-- Use :map or <leader>sk to see all keymaps
-- Also use <leader> and wait for WhichKey to show options!

-- (<M> is alt!)

-- Files and menu
-- <leader>e -> toggle file explorer
-- <leader>f -> search files under current directory
-- <leader>s -> search menu
-- <leader>; -> go to dashboard

-- Terminal
-- <C-\> | <M-3> -> open float terminal
-- <M-1>         -> split terminal bottom
-- <M-2>         -> split terminal right

-- LSP (<leader>l)
-- M  -> hover symbol (double tap to go inside window and scroll)
-- gd -> go to definition
-- gD -> go to declaration
-- gI -> go to implementation
-- gs -> signature help
-- gr -> go to references
-- gl -> show line diagnostics (glgl to go inside window)

-- Completion (All for insert mode only)
-- <C-space>              -> trigger completion menu
-- <CR> | <C-y>           -> confirm selection
-- <C-k> | <Up> | <S-Tab> -> select previous item
-- <C-j> | <Down> | <Tab> -> select next item
-- <C-d>                  -> scroll docs up
-- <C-f>                  -> scroll docs down
-- <CR> | <Tab>           -> jump to next jumpable in a snippet
-- <S-Tab>                -> jump to previous in a snippet


-- Editing
-- <leader>/ -> toggle comment current line or visual selection
-- gb        -> block comment visual selection
-- <M-j>     -> Move line down
-- <M-k>     -> Move line up

-- Splits
-- <C-{Up|Down}> -> decrease/increase vertical size
-- <C-{Left|Right}> -> decrease/increase horizontal size
--
-- These make sense if currently in top left split


-------------------------------------------------------------------------------
-- Debug configurations
-------------------------------------------------------------------------------
-- require('dap.ext.vscode').load_launchjs()

-- Python ---------------------------------------------------------------------
local dap = require('dap')
dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = "${file}",
        pythonPath = function()
            return '/usr/bin/python'
        end,
    }
}

-- C/C++ ----------------------------------------------------------------------
dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = '/home/matthieu/.local/share/lvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}
dap.configurations.cpp = {
    {
        -- This usually gives good paths too
        -- vim.lsp.buf.list_workspace_folders()[1]
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = function()
            return vim.fn.input('Working directory: ', vim.fn.getcwd() .. '/', 'file')
        end,
        stopAtEntry = true,
        setupCommands = {
            {
                text = '-enable-pretty-printing',
                description = 'enable pretty printing',
                ignoreFailures = false
            },
        }
    }
}
dap.configurations.c = dap.configurations.cpp

-- JS -------------------------------------------------------------------------
require("dap-vscode-js").setup({
    debugger_path = "/home/matthieu/.local/share/lunarvim/site/pack/lazy/opt/vscode-js-debug",
    adapters = {
        'pwa-node',
        'pwa-chrome',
        'pwa-msedge',
        'node-terminal',
        'pwa-extensionHost'
    }, -- which adapters to register in nvim-dap
})

for _, language in ipairs({ "typescript", "javascript" }) do
    require("dap").configurations[language] = {
        -- https://github.com/mxsdev/nvim-dap-vscode-js
        -- https://github.com/microsoft/vscode-js-debug/blob/main/OPTIONS.md

        -- Node
        {
            type = "pwa-node",
            request = "launch",
            name = "Node Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Node Attach",
            processId = require 'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**" },
            restart = true,
            sourceMaps = true,
        },
        -- Jest
        -- NOTE: For async tests, sometimes it's like there are 2 debugger
        -- instances, once the first is closed, the second can be manipulated
        -- correctly. The first won't move, saying "no threads paused"
        -- https://jestjs.io/docs/troubleshooting
        {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
                "-r", "tsconfig-paths/register",
                "-r", "ts-node/register",
                "${workspaceFolder}/node_modules/jest/bin/jest.js",
                "--runInBand",
            },
            rootPath = function()
                return vim.fn.input('Working directory: ', vim.lsp.buf.list_workspace_folders()[1] .. '/', 'file')
            end,
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
        },
        -- Projet 2 Polymtl...
        -- Use standard Node Attach
        -- {
        --     -- https://stackoverflow.com/a/58357642
        --     type = "pwa-node",
        --     request = "attach",
        --     name = "Debug server (Attach)",
        --     port = 9229,
        --     skipFiles = { "<node_internals>/**" },
        --     restart = true,
        --     sourceMaps = true,
        --     localRoot = function()
        --         return vim.fn.input('Project root: ', vim.lsp.buf.list_workspace_folders()[1] .. '/', 'file')
        --         -- "${workspaceFolder}/server"),
        --     end,
        --     protocol = "inspector"
        -- },
        {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Client With Debug (must call npm start before!)",
            url = "http://localhost:4200",
            webRoot = function()
                return vim.fn.input('Web root: ', vim.lsp.buf.list_workspace_folders()[1] .. '/', 'file')
                -- "${workspaceFolder}/client")
            end
        }
    }
end
