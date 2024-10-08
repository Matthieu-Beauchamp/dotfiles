-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<C-Right>', '<C-w>>', { desc = 'Increase window width' })
vim.keymap.set('n', '<C-Left>', '<C-w><', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Down>', '<C-w>+', { desc = 'Increase window width' })
vim.keymap.set('n', '<C-Up>', '<C-w>-', { desc = 'Decrease window width' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- jk to exit insert mode
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- quick write and quick exit
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Close window' })

-- Buffer: close (all), prev, next
vim.keymap.set('n', '<leader>b', '', { desc = '[B]uffer' })
vim.keymap.set('n', '<leader>bc', '<cmd> bd<CR>', { desc = '[B]uffer [c]lose' })

--TODO: keymap that takes buffer number as prefix

-- vim.keymap.set('n', '<leader>bC', '<cmd> %bd|e#|bnext|bd<CR>', { desc = '[B]uffer [C]lose all except current' })
vim.keymap.set('n', '<leader>bC', function()
  for _, buf in ipairs(vim.fn.getbufinfo { buflisted = 1 }) do
    if buf.bufnr ~= vim.api.nvim_get_current_buf() then
      vim.api.nvim_buf_delete(buf.bufnr, {})
    end
  end
end, { desc = '[B]uffer [C]lose all except current' })

vim.keymap.set('n', '<leader>bp', '<cmd> bprev<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bn', '<cmd> bnext<CR>', { desc = '[B]uffer [P]revious' })

-- Splits
vim.keymap.set('n', '<leader>v', '<cmd> vsplit<CR>', { desc = '[V]ertical split' })
vim.keymap.set('n', '<leader>h', '<cmd> split<CR>', { desc = '[H]orizontal split' })

-- Nvim tree
vim.keymap.set('n', '<leader>e', '<cmd> NvimTreeToggle<CR>', { desc = '[E]xplorer toggle' })
vim.keymap.set('n', '<leader>ef', '<cmd> NvimTreeFindFileToggle<CR>', { desc = '[E]xplorer [f]ind file toggle' })

-- vim: ts=2 sts=2 sw=2 et
