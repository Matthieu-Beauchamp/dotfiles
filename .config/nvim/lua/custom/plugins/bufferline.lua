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
        numbers = function(opts)
          return string.format('[%s]', opts.ordinal)
        end,
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
      },
    }
  end,
}
