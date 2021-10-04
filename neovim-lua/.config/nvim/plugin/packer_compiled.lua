-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/itziar/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/itziar/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/itziar/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/itziar/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/itziar/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["BetterLua.vim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/BetterLua.vim"
  },
  ["Nvim-R"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/Nvim-R"
  },
  ["barbar.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/barbar.nvim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/cmp-buffer"
  },
  ["cmp-latex-symbols"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/cmp-latex-symbols"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp"
  },
  ["cmp-nvim-ultisnips"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/cmp-nvim-ultisnips"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/cmp-path"
  },
  ["cmp-treesitter"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/cmp-treesitter"
  },
  ["dashboard-nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/dashboard-nvim"
  },
  ["discord.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/discord.nvim"
  },
  ["formatter.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/formatter.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["glow.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/glow.nvim"
  },
  ["indent-guides.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/indent-guides.nvim"
  },
  ["julia-vim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/julia-vim"
  },
  ["lsp-colors.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/lsp-colors.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/lsp-status.nvim"
  },
  ["lsp_extensions.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/lsp_extensions.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  ["lualine.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  neorg = {
    loaded = false,
    needs_bufread = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/neorg"
  },
  nerdcommenter = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nerdcommenter"
  },
  ["nvim-cmp"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nvim-cmp"
  },
  ["nvim-code-action-menu"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nvim-code-action-menu"
  },
  ["nvim-lightbulb"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nvim-lightbulb"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lsputils"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nvim-lsputils"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  popfix = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/popfix"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["rust.vim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/rust.vim"
  },
  sonokai = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/sonokai"
  },
  ["switch.vim"] = {
    config = { "\27LJ\1\2g\0\0\5\0\a\0\t4\0\0\0007\0\1\0007\0\2\0%\1\3\0%\2\4\0%\3\5\0003\4\6\0>\0\5\1G\0\1\0\1\0\2\vsilent\2\fnoremap\2\16:Switch<CR>\6-\6n\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/switch.vim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\1\0029\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\ftrouble\frequire\0" },
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/trouble.nvim"
  },
  ultisnips = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/ultisnips"
  },
  ["vim-closer"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-closer"
  },
  ["vim-dadbod"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-dadbod"
  },
  ["vim-dadbod-completion"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-dadbod-completion"
  },
  ["vim-dadbod-ui"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-dadbod-ui"
  },
  ["vim-endwise"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-endwise"
  },
  ["vim-floaterm"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-floaterm"
  },
  ["vim-go"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-go"
  },
  ["vim-lsp-cxx-highlight"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-lsp-cxx-highlight"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-matchup"
  },
  ["vim-mathematica"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-mathematica"
  },
  ["vim-pandoc"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-pandoc"
  },
  ["vim-pandoc-syntax"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-pandoc-syntax"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-polyglot"
  },
  ["vim-snippets"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-snippets"
  },
  ["vim-starwars"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-starwars"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  vimtex = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vimtex"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\1\2;\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\14which-key\frequire\0" },
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/which-key.nvim"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: switch.vim
time([[Config for switch.vim]], true)
try_loadstring("\27LJ\1\2g\0\0\5\0\a\0\t4\0\0\0007\0\1\0007\0\2\0%\1\3\0%\2\4\0%\3\5\0003\4\6\0>\0\5\1G\0\1\0\1\0\2\vsilent\2\fnoremap\2\16:Switch<CR>\6-\6n\20nvim_set_keymap\bapi\bvim\0", "config", "switch.vim")
time([[Config for switch.vim]], false)
-- Config for: trouble.nvim
time([[Config for trouble.nvim]], true)
try_loadstring("\27LJ\1\0029\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\ftrouble\frequire\0", "config", "trouble.nvim")
time([[Config for trouble.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\1\2;\0\0\2\0\3\0\a4\0\0\0%\1\1\0>\0\2\0027\0\2\0002\1\0\0>\0\2\1G\0\1\0\nsetup\14which-key\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType norg ++once lua require("packer.load")({'neorg'}, { ft = "norg" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/itziar/.local/share/nvim/site/pack/packer/opt/neorg/ftdetect/norg.vim]], true)
vim.cmd [[source /home/itziar/.local/share/nvim/site/pack/packer/opt/neorg/ftdetect/norg.vim]]
time([[Sourcing ftdetect script at: /home/itziar/.local/share/nvim/site/pack/packer/opt/neorg/ftdetect/norg.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
