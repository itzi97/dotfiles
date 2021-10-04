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
    ['<CR>'] = cmp.mapping.confirm {
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

-- {{{ Tab completion

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return cmp.mapping.complete()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- }}}

-- {{{ Ultisnips

-- Completion shortcuts for Ultisnips
vim.g.UltiSnipsExpandTrigger = '<c-k>'
vim.g.UltiSnipsJumpForwardTrigger = '<C-w>'
vim.g.UltiSnipsJumpBackwardTrigger = '<C-b>'

-- }}}
