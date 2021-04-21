" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
local package_path_str = "/home/itziar/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/itziar/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/itziar/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/itziar/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/itziar/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

_G.packer_plugins = {
  ["BetterLua.vim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/BetterLua.vim"
  },
  ["barbar.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/barbar.nvim"
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
    config = { "\27LJ\2\0026\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
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
  nerdcommenter = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nerdcommenter"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/nvim-compe"
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
  ["snippets.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/snippets.nvim"
  },
  sonokai = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/sonokai"
  },
  ["switch.vim"] = {
    config = { "\27LJ\2\2g\0\0\5\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\4\0'\3\5\0005\4\6\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\16:Switch<CR>\6-\6n\20nvim_set_keymap\bapi\bvim\0" },
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/switch.vim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-closer"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-closer"
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
  ["vim-matchup"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-matchup"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-polyglot"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  vimtex = {
    loaded = true,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/start/vimtex"
  }
}

-- Config for: gitsigns.nvim
try_loadstring("\27LJ\2\0026\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
-- Config for: switch.vim
try_loadstring("\27LJ\2\2g\0\0\5\0\a\0\t6\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\4\0'\3\5\0005\4\6\0B\0\5\1K\0\1\0\1\0\2\vsilent\2\fnoremap\2\16:Switch<CR>\6-\6n\20nvim_set_keymap\bapi\bvim\0", "config", "switch.vim")
END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
