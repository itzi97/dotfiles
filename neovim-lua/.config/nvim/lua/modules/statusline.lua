-- Status line
require'lualine'.setup {
  options = {
    theme = 'ayu_dark',
    section_separators = {'', ''},
    component_separators = {'|', '|'},
    icons_enabled = true
  },
  sections = {
    lualine_a = {{'mode', upper = true}},
    lualine_b = {{'branch', icon = ''}, 'diff'},
    lualine_c = {{'filename', file_status = true}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {
      {
        'diagnostics',
        sources = {'nvim_lsp'},
        sections = {'error', 'warn', 'info'}
      }
    },
    lualine_z = {'progress', {'location', icon = ''}}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {'fugitive'}
}

-- Tabline
vim.g.bufferline = {auto_hide = true}
