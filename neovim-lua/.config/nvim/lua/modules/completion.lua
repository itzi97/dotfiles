local map = vim.api.nvim_set_keymap

-- {{{ nvim-comp

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
             vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col)
                 :match('%s') == nil
end

local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

      -- For `luasnip` user.
      -- require('luasnip').lsp_expand(args.body)

      -- For `ultisnips` user.
      vim.fn["UltiSnips#Anon"](args.body)
    end
  },
  formatting = {
    format = function(entry, vim_item)
      -- fancy icons and a name of kind
      vim_item.kind =
          require("lspkind").presets.default[vim_item.kind] .. " " ..
              vim_item.kind

      -- set a name for each source
      vim_item.menu = ({
        buffer = "[Buffer]",
        -- dadbod = "[DadBod]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        ultisnips = "[UltiSnips]",
        nvim_lua = "[Lua]",
        treesitter = "[Treesitter]",
        latex_symbols = "[Latex]"
      })[entry.source.name]
      return vim_item
    end
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    -- ['<CR>'] = cmp.mapping.confirm({select = true}),
    ['<C-space>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true
    },

    ['<Tab>'] = function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,

    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end
  },
  sources = {
    {name = 'nvim_lsp'}, {name = 'ultisnips'}, {name = 'buffer'},
    {name = 'treesitter'}, -- {name = "latex_symbols"}, 
    {name = "path"}, {name = 'vim-dadbod-completion'}, {name = "neorg"}
  }
})

-- }}}

-- {{{ Ultisnips

-- Completion shortcuts for Ultisnips
vim.g.UltiSnipsExpandTrigger = '<C-w>'
vim.g.UltiSnipsJumpForwardTrigger = '<C-w>'
vim.g.UltiSnipsJumpBackwardTrigger = '<C-b>'

-- }}}
