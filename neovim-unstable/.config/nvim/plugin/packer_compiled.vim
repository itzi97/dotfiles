" Automatically generated packer.nvim plugin loader code

if !has('nvim')
  finish
endif

lua << END
local plugins = {
  ["BetterLua.vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/BetterLua.vim"
  },
  ["completion-treesitter"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/completion-treesitter"
  },
  ["haskell-vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/haskell-vim"
  },
  ["julia-vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/julia-vim"
  },
  ["nlua.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/nlua.nvim"
  },
  ["packer.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["rust.vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/rust.vim"
  },
  ["vim-go"] = {
    config = { "\27LJ\1\0024\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0\21GoUpdateBinaries\bcmd\bvim\0" },
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/vim-go"
  },
  ["vim-lsp-cxx-highlight"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/vim-lsp-cxx-highlight"
  },
  ["vim-nix"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/vim-nix"
  },
  ["vim-pandoc"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/vim-pandoc"
  },
  vimtex = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/itziar/.local/share/nvim/site/pack/packer/opt/vimtex"
  }
}

local function handle_bufread(names)
  for _, name in ipairs(names) do
    local path = plugins[name].path
    for _, dir in ipairs({ 'ftdetect', 'ftplugin', 'after/ftdetect', 'after/ftplugin' }) do
      if #vim.fn.finddir(dir, path) > 0 then
        vim.cmd('doautocmd BufRead')
        return
      end
    end
  end
end

_packer_load = nil

local function handle_after(name, before)
  local plugin = plugins[name]
  plugin.load_after[before] = nil
  if next(plugin.load_after) == nil then
    _packer_load({name}, {})
  end
end

_packer_load = function(names, cause)
  local some_unloaded = false
  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      some_unloaded = true
      break
    end
  end

  if not some_unloaded then return end

  local fmt = string.format
  local del_cmds = {}
  local del_maps = {}
  for _, name in ipairs(names) do
    if plugins[name].commands then
      for _, cmd in ipairs(plugins[name].commands) do
        del_cmds[cmd] = true
      end
    end

    if plugins[name].keys then
      for _, key in ipairs(plugins[name].keys) do
        del_maps[key] = true
      end
    end
  end

  for cmd, _ in pairs(del_cmds) do
    vim.cmd('silent! delcommand ' .. cmd)
  end

  for key, _ in pairs(del_maps) do
    vim.cmd(fmt('silent! %sunmap %s', key[1], key[2]))
  end

  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      vim.cmd('packadd ' .. name)
      vim._update_package_paths()
      if plugins[name].config then
        for _i, config_line in ipairs(plugins[name].config) do
          loadstring(config_line)()
        end
      end

      if plugins[name].after then
        for _, after_name in ipairs(plugins[name].after) do
          handle_after(after_name, name)
          vim.cmd('redraw')
        end
      end

      plugins[name].loaded = true
    end
  end

  handle_bufread(names)

  if cause.cmd then
    local lines = cause.l1 == cause.l2 and '' or (cause.l1 .. ',' .. cause.l2)
    vim.cmd(fmt('%s%s%s %s', lines, cause.cmd, cause.bang, cause.args))
  elseif cause.keys then
    local keys = cause.keys
    local extra = ''
    while true do
      local c = vim.fn.getchar(0)
      if c == 0 then break end
      extra = extra .. vim.fn.nr2char(c)
    end

    if cause.prefix then
      local prefix = vim.v.count and vim.v.count or ''
      prefix = prefix .. '"' .. vim.v.register .. cause.prefix
      if vim.fn.mode('full') == 'no' then
        if vim.v.operator == 'c' then
          prefix = '' .. prefix
        end

        prefix = prefix .. vim.v.operator
      end

      vim.fn.feedkeys(prefix, 'n')
    end

    -- NOTE: I'm not sure if the below substitution is correct; it might correspond to the literal
    -- characters \<Plug> rather than the special <Plug> key.
    vim.fn.feedkeys(string.gsub(string.gsub(cause.keys, '^<Plug>', '\\<Plug>') .. extra, '<[cC][rR]>', '\r'))
  elseif cause.event then
    vim.cmd(fmt('doautocmd <nomodeline> %s', cause.event))
  elseif cause.ft then
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeplugin', cause.ft))
    vim.cmd(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeindent', cause.ft))
  end
end

-- Runtimepath customization

-- Pre-load configuration
-- Post-load configuration
-- Conditional loads
-- Load plugins in order defined by `after`
vim._update_package_paths()
END

function! s:load(names, cause) abort
call luaeval('_packer_load(_A[1], _A[2])', [a:names, a:cause])
endfunction


" Command lazy-loads

" Keymap lazy-loads

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  au FileType lua ++once call s:load(['BetterLua.vim', 'nlua.nvim'], { "ft": "lua" })
  au FileType pandoc ++once call s:load(['vimtex', 'vim-pandoc'], { "ft": "pandoc" })
  au FileType go ++once call s:load(['vim-go'], { "ft": "go" })
  au FileType nix ++once call s:load(['vim-nix'], { "ft": "nix" })
  au FileType rust ++once call s:load(['rust.vim'], { "ft": "rust" })
  au FileType rmarkdown ++once call s:load(['vim-pandoc'], { "ft": "rmarkdown" })
  au FileType markdown ++once call s:load(['vimtex', 'vim-pandoc'], { "ft": "markdown" })
  au FileType julia ++once call s:load(['julia-vim'], { "ft": "julia" })
  au FileType haskell ++once call s:load(['haskell-vim'], { "ft": "haskell" })
  au FileType c ++once call s:load(['vim-lsp-cxx-highlight'], { "ft": "c" })
  au FileType cpp ++once call s:load(['vim-lsp-cxx-highlight'], { "ft": "cpp" })
  au FileType tex ++once call s:load(['vimtex'], { "ft": "tex" })
  " Event lazy-loads
augroup END
