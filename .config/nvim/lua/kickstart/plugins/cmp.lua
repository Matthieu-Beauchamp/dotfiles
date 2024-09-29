local truncate = function(text, max_width)
  if #text > max_width then
    return string.sub(text, 1, max_width) .. '…'
  else
    return text
  end
end

return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'onsails/lspkind.nvim',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- https://github.com/wookayin/dotfiles/blob/c6a7c1c38518f8448b5ec8e6bd288eb4206449e4/nvim/lua/config/lsp.lua#L422
        -- Added this to get completion sources
        formatting = {
          format = function(entry, vim_item)
            -- Truncate the item if it is too long
            vim_item.abbr = truncate(vim_item.abbr, 80)

            -- fancy icons and a name of kind
            pcall(function() -- protect the call against potential API breakage (lspkind GH-45).
              local lspkind = require 'lspkind'
              vim_item.kind_symbol = (lspkind.symbolic or lspkind.get_symbol)(vim_item.kind)
              vim_item.kind = ' ' .. vim_item.kind_symbol .. ' ' .. vim_item.kind
            end)

            -- The 'menu' section: source, detail information (lsp, snippet), etc.
            -- set a name for each source (see the sources section below)
            vim_item.menu = ({
              buffer = 'Buffer',
              nvim_lsp = 'LSP',
              ultisnips = '',
              nvim_lua = 'Lua',
              latex_symbols = 'Latex',
            })[entry.source.name] or string.format('%s', entry.source.name)

            -- highlight groups for item.menu
            vim_item.menu_hl_group = ({
              buffer = 'CmpItemMenuBuffer',
              nvim_lsp = 'CmpItemMenuLSP',
              path = 'CmpItemMenuPath',
              ultisnips = 'CmpItemMenuSnippet',
            })[entry.source.name] -- default is CmpItemMenu

            -- detail information (optional)
            local cmp_item = entry:get_completion_item() --- @type lsp.CompletionItem

            if entry.source.name == 'nvim_lsp' then
              -- Display which LSP servers this item came from.
              local lspserver_name = nil
              pcall(function()
                lspserver_name = entry.source.source.client.name
                vim_item.menu = vim_item.menu .. ' [' .. lspserver_name .. ']'
              end)

              -- Some language servers provide details, e.g. type information.
              -- The details info hide the name of lsp server, but mostly we'll have one LSP
              -- per filetype, and we use special highlights so it's OK to hide it..
              local detail_txt = (function(cmp_item)
                if not cmp_item.detail then
                  return nil
                end
                --   if lspserver_name == 'pyright' and cmp_item.detail == 'Auto-import' then
                --     local label = (cmp_item.labelDetails or {}).description
                --     return label and (' ' .. truncate(label, 20)) or nil
                --   else
                return truncate(cmp_item.detail, 50)
                --   end
              end)(cmp_item)

              if detail_txt then
                vim_item.menu = vim_item.menu .. ' (' .. detail_txt .. ')'
                vim_item.menu_hl_group = 'CmpItemMenuDetail'
              end
              -- elseif entry.source.name == 'ultisnips' then
              --   if (cmp_item.snippet or {}).description then
              --     vim_item.menu = truncate(cmp_item.snippet.description, 40)
              --   end
            end

            -- Add a little bit more padding
            vim_item.menu = ' ' .. vim_item.menu
            return vim_item
          end,
        },
        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
