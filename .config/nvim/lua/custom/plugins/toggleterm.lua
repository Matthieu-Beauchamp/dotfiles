-- Adapted from lvim's implementation
-- TODO: simplify, it's laggy
-- TODO: Add support for <count> argument to support targetting terminals

local MIN_TERM_SIZE = 10

--- Get current buffer size
---@return {width: number, height: number}
local function get_buf_size()
  local cbuf = vim.api.nvim_get_current_buf()
  local bufinfo = vim.tbl_filter(function(buf)
    return buf.bufnr == cbuf
  end, vim.fn.getwininfo(vim.api.nvim_get_current_win()))[1]
  if bufinfo == nil then
    return { width = -1, height = -1 }
  end
  return { width = bufinfo.width, height = bufinfo.height }
end

--- Get the dynamic terminal size in cells
---@param direction string
---@param size number
---@return integer
local function get_dynamic_terminal_size(direction, size)
  size = size or MIN_TERM_SIZE
  if direction ~= 'float' and tostring(size):find('.', 1, true) then
    size = math.min(size, 1.0)
    local buf_sizes = get_buf_size()
    local buf_size = direction == 'horizontal' and buf_sizes.height or buf_sizes.width
    return math.max(buf_size * size, MIN_TERM_SIZE)
  else
    return size
  end
end

local function get_opts()
  return {
    -- size can be a number or function which is passed the current terminal
    size = MIN_TERM_SIZE,
    open_mapping = [[<c-`>]],
    persist_size = false,

    -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
    direction = 'horizontal',

    -- This field is only relevant if direction is set to 'float'
    float_opts = {
      -- The border key is *almost* the same as 'nvim_win_open'
      -- see :h nvim_win_open for details on borders however
      -- the 'curved' border is a custom border type
      -- not natively supported but implemented in this plugin.
      -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
      border = 'curved',
    },
    shade_terminals = false,
    winbar = {
      enabled = false,
      --- @param term Terminal
      name_formatter = function(term)
        return term.count
      end,
    },
  }
end

local function setup()
  require('toggleterm').setup(get_opts())
end

local function _exec_toggle(opts)
  local Terminal = require('toggleterm.terminal').Terminal
  local term = Terminal:new { cmd = opts.cmd, count = opts.count, direction = opts.direction }
  term:toggle(opts.size, opts.direction)
end

local function add_exec(opts)
  vim.keymap.set({ 'n', 't' }, opts.keymap, function()
    _exec_toggle { cmd = opts.cmd, count = opts.count, direction = opts.direction, size = opts.size() }
  end, { desc = opts.label, noremap = true, silent = true })
end

local function init(execs)
  setup()

  for i, exec in pairs(execs) do
    local term_opts = {
      keymap = exec[1],
      label = exec[2],
      direction = exec[3],
      count = i,
      size = function()
        return get_dynamic_terminal_size(exec[3], exec[4])
      end,
    }

    add_exec(term_opts)
  end
end

-------------------------------------------------------------------------------

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    init {
      { '<M-1>', 'Horizontal Terminal 1', 'horizontal', 0.3 },
      { '<M-2>', 'Horizontal Terminal 2', 'horizontal', 0.3 },
      { '<M-3>', 'Float Terminal', 'float', nil },
    }

    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'
  end,
}
