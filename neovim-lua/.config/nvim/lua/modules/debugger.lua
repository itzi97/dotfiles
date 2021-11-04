local dap = require('dap')

-- {{{ lldb C++, C, Rust

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "lldb",
    request = "launch",
    program = function()
      return vim.fn
                 .input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
    env = function()
      local variables = {}
      for k, v in pairs(vim.fn.environ()) do
        table.insert(variables, string.format("%s=%s", k, v))
      end
      return variables
    end
  }
}

-- If you want to use this for rust and c, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- }}}

-- {{{ debugpy Python

local dap_python = require 'dap-python'

dap_python.setup('~/.virtualenvs/debugpy/bin/python')
dap_python.test_runner = 'pytest'

vim.cmd [[ nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR> ]]
vim.cmd [[ nnoremap <silent> <leader>df :lua require('dap-python').test_class()<CR> ]]
vim.cmd [[ vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR> ]]

-- }}}

-- {{{ Lua

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
    host = function()
      local value = vim.fn.input('Host [127.0.0.1]: ')
      if value ~= "" then return value end
      return '127.0.0.1'
    end,
    port = function()
      local val = tonumber(vim.fn.input('Port: '))
      assert(val, "Please provide a port number")
      return val
    end
  }
}

dap.adapters.nlua = function(callback, config)
  callback({type = 'server', host = config.host, port = config.port})
end

-- }}}

-- {{{ Extension: Virtual text

-- virtual text deactivated (default)
-- vim.g.dap_virtual_text = false
-- show virtual text for current frame (recommended)
-- vim.g.dap_virtual_text = true
-- request variable values for all frames (experimental)
require'nvim-dap-virtual-text'.setup()
--vim.g.dap_virtual_text = 'all frames'

-- }}}

-- {{{ Keymaps

local M = {}
local map = vim.api.nvim_set_keymap
local opts = {noremap = false, silent = true}

function M.reload_continue()
  package.loaded['dap_config'] = nil
  require('dap_config')
  dap.continue()
end

map('n', 'Dc', [[<cmd>lua require'dap'.continue()<CR>]], opts)
map('n', 'DC', [[<cmd>lua require'dap_setup'.reload_continue()<CR>]], opts)
map('n', 'Dt', [[<cmd>lua require'dap'.toggle_breakpoint()<CR>]], opts)
map('n', 'Dl', [[<cmd>lua require'dap'.list_breakpoints()<CR>]], opts)
map('n', 'So', [[<cmd>lua require'dap'.step_over()<CR>]], opts)
map('n', 'Si', [[<cmd>lua require'dap'.step_into()<CR>]], opts)

-- Hover key whilst session is active
local api = vim.api
local keymap_restore = {}
dap.listeners.after['event_initialized']['me'] = function()
  for _, buf in pairs(api.nvim_list_bufs()) do
    local keymaps = api.nvim_buf_get_keymap(buf, 'n')
    for _, keymap in pairs(keymaps) do
      if keymap.lhs == "K" then
        table.insert(keymap_restore, keymap)
        api.nvim_buf_del_keymap(buf, 'n', 'K')
      end
    end
  end
  api.nvim_set_keymap('n', 'K',
                      '<Cmd>lua require("dap.ui.variables").hover()<CR>',
                      {silent = true})
end

dap.listeners.after['event_terminated']['me'] = function()
  for _, keymap in pairs(keymap_restore) do
    api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs,
                            {silent = keymap.silent == 1})
  end
  keymap_restore = {}
end

-- }}}

-- {{{ Signs

vim.fn.sign_define('DapBreakpoint',
                   {text = '🛑', texthl = '', linehl = '', numhl = ''})

-- }}}
