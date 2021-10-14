local nvim_lsp = require('lspconfig')

-- {{{ On attach

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- gD    - Go to declaration
  -- gd    - Go to definition
  -- K     - Hover over definition
  -- gi    - Implementation
  -- <C-k> - See signature help
  -- <space>wa - Add workspace folder
  local opts = {noremap = true, silent = true}
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa',
                 '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr',
                 '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl',
                 '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                 opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>',
                 opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e',
                 '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q',
                 '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>",
                   opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<space>f",
                   "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
			hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
			hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
			hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
			augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]], false)
  end
end

-- }}}

-- {{{ Diagnostics

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = {spacing = 4, prefix = ' '},
      signs = true,
      update_in_insert = true
    })

-- }}}

-- {{{ LSPKind
-- Show symbols for LSP
require'lspkind'.init({
  with_text = false,
  symbol_map = {
    Text = '',
    Method = 'ƒ',
    Function = '',
    Constructor = '',
    Variable = '',
    Class = '',
    Interface = 'ﰮ',
    Module = '',
    Property = '',
    Unit = '',
    Value = '',
    Enum = '了',
    Keyword = '',
    Snippet = '﬌',
    Color = '',
    File = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = ''
  }
})

-- }}}

-- {{{ TODO: Lspsaga

require'lspsaga'.init_lsp_saga()
local saga = require 'lspsaga'

saga.init_lsp_saga {
  finder_action_keys = {
    open = 'o',
    vsplit = 's',
    split = 'i',
    quit = 'q',
    scroll_down = '<C-f>',
    scroll_up = '<C-b>' -- quit can be a table
  },
  code_action_keys = {quit = 'q', exec = '<CR>'},
  rename_action_keys = {
    quit = '<C-c>',
    exec = '<CR>' -- quit can be a table
  },
  -- 1: thin border | 2: rounded border | 3: thick border | 4: ascii border
  border_style = 1
}

-- }}}

-- {{{ LSP Extensions
require'lsp_extensions'.inlay_hints {
  highlight = "Comment",
  prefix = " » ",
  aligned = false,
  only_current_line = false,
  enabled = {"ChainingHint"}
}
-- }}}

-- {{{ Code Actions

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

-- Showing defaults
require'nvim-lightbulb'.update_lightbulb {
  sign = {
    enabled = true,
    -- Priority of the gutter sign
    priority = 10
  },
  float = {
    enabled = false,
    -- Text to show in the popup float
    text = "💡",
    -- Available keys for window options:
    -- - height     of floating window
    -- - width      of floating window
    -- - wrap_at    character to wrap at for computing height
    -- - max_width  maximal width of floating window
    -- - max_height maximal height of floating window
    -- - pad_left   number of columns to pad contents at left
    -- - pad_right  number of columns to pad contents at right
    -- - pad_top    number of lines to pad contents at top
    -- - pad_bottom number of lines to pad contents at bottom
    -- - offset_x   x-axis offset of the floating window
    -- - offset_y   y-axis offset of the floating window
    -- - anchor     corner of float to place at the cursor (NW, NE, SW, SE)
    -- - winblend   transparency of the window (0-100)
    win_opts = {}
  },
  virtual_text = {
    enabled = true,
    -- Text to show at virtual text
    text = "💡"
  },
  status_text = {
    enabled = false,
    -- Text to provide when code actions are available
    text = "💡",
    -- Text to provide when no actions are available
    text_unavailable = ""
  }
}

-- }}}

-- {{{ TODO: LSP Utils

-- vim.lsp.handlers['textDocument/codeAction'] =
-- require'lsputil.codeAction'.code_action_handler
-- vim.lsp.handlers['textDocument/references'] =
-- require'lsputil.locations'.references_handler
-- vim.lsp.handlers['textDocument/definition'] =
-- require'lsputil.locations'.definition_handler
-- vim.lsp.handlers['textDocument/declaration'] =
-- require'lsputil.locations'.declaration_handler
-- vim.lsp.handlers['textDocument/typeDefinition'] =
-- require'lsputil.locations'.typeDefinition_handler
-- vim.lsp.handlers['textDocument/implementation'] =
-- require'lsputil.locations'.implementation_handler
-- vim.lsp.handlers['textDocument/documentSymbol'] =
-- require'lsputil.symbols'.document_handler
-- vim.lsp.handlers['workspace/symbol'] =
-- require'lsputil.symbols'.workspace_handler

-- }}}

-- {{{ Language server setup

-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                     .protocol
                                                                     .make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true;

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = {"gopls", "pyright", "rust_analyzer", "tsserver", "texlab"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {capabilities = capabilities, on_attach = on_attach}
end

-- {{{ Lua language server

-- local sumneko_root_path = vim.fn.getenv("HOME") .. "/.local/share/sumneko-lua/"
nvim_lsp.sumneko_lua.setup {
  cmd = {
    "/bin/lua-language-server", "-E", "/usr/share/lua-language-server/main.lua"
  },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';')
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {"vim"}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
      }
    }
  }
}

-- }}}

-- {{{ C++ servers

nvim_lsp.ccls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  init_options = {highlight = {lsRanges = true}}
}

-- }}}

-- }}}
