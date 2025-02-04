vim.filetype.add({
  pattern = {
    [".*%.component%.html"] = "htmlangular", -- Sets the filetype to `htmlangular` if it matches the pattern
  },
})

vim.cmd('runtime! ftplugin/html.vim!')
