local catpuccin = {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'catppuccin-frappe'
  end,
}

local dracula = {
  'Mofiqul/dracula.nvim',
  name = 'dracula',
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'dracula'
  end,
}

return dracula
