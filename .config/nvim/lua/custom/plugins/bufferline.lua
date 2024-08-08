return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    vim.opt.termguicolors = true

    local bufferline = require 'bufferline'
    bufferline.setup {
      options = {
        separator_style = 'slope',
        numbers = 'buffer_id',
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
      },
    }
  end,
}
