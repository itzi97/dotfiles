-- Helper functions "nvim-lua/lsp-status.nvim"
local function getWords() return tostring(vim.fn.wordcount().words) end

-- lsp status
local lsp_status = require 'lsp-status'
lsp_status.register_progress()
local function LspStatus()
  if #vim.lsp.buf_get_clients() > 0 then return lsp_status.status() end
  return ''
end

-- Status line
require'lualine'.setup {
  options = {
    theme = 'material-nvim',
    section_separators = {'', ''},
    component_separators = {'|', '|'},
    icons_enabled = true
  },
  sections = {
    lualine_a = {{'mode', upper = true}},
    lualine_b = {{'branch', icon = ''}, 'diff'},
    lualine_c = {{'filename', file_status = true}, LspStatus},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {
      {
        'diagnostics',
        sources = {'nvim_lsp'},
        sections = {'error', 'warn', 'info'}
      }
    },
    lualine_z = {
      'progress', {getWords, icon = ''}, {'location', icon = ''}
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {'fugitive', 'nvim-tree'}
}

-- Tabline
vim.g.bufferline = {auto_hide = true}
