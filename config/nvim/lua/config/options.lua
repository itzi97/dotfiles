-- Editor behaviour. No plugins referenced here, so this file alone gives a
-- usable neovim if every plugin fails to load.

-- --- unused remote-plugin providers ----------------------------------------
-- Neovim can host plugins written in Python, Node, Perl and Ruby. Nothing here
-- uses any of them, and leaving them enabled means :checkhealth permanently
-- reports one ❌ and three ⚠️ about missing `neovim` packages that are never
-- going to be installed.
--
-- Turning them off is not cosmetic: a healthcheck you've learned to ignore
-- can't tell you when something real breaks. If a future plugin needs one,
-- checkhealth will say so and the line comes back out.
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local opt = vim.opt

-- --- visible state ---------------------------------------------------------
opt.number = true
opt.relativenumber = true      -- makes 5j / 12k a glance rather than a count
opt.cursorline = true
opt.signcolumn = "yes"         -- always on: without it the text jumps sideways
                               -- every time a git sign or diagnostic appears
opt.scrolloff = 8              -- keep context above/below the cursor
opt.wrap = false
opt.termguicolors = true

-- --- indentation -----------------------------------------------------------
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true

-- --- searching -------------------------------------------------------------
opt.ignorecase = true
opt.smartcase = true           -- ignorecase, UNLESS the pattern has a capital
opt.hlsearch = true            -- cleared by <Esc>, mapped in keymaps.lua
opt.incsearch = true

-- --- files and undo --------------------------------------------------------
opt.swapfile = false
opt.backup = false
-- Persistent undo is the single highest-value option in this file: undo
-- survives closing the file, closing neovim, and rebooting.
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- --- splits ----------------------------------------------------------------
opt.splitright = true          -- new vertical splits go right, not left
opt.splitbelow = true

-- --- behaviour -------------------------------------------------------------
opt.updatetime = 250           -- how fast CursorHold fires (diagnostics, gitsigns)
opt.timeoutlen = 400           -- how long to wait for a mapping sequence
opt.mouse = "a"                -- principle #9: keyboard-first, mouse-tolerant
opt.clipboard = "unnamedplus"  -- share the system clipboard
opt.confirm = true             -- prompt instead of failing on :q with changes

-- Show whitespace that matters. Trailing spaces and hard tabs are invisible
-- until they cause a diff or break a Makefile.
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Live preview of :substitute in a split.
opt.inccommand = "split"

-- --- diagnostics -----------------------------------------------------------
-- Virtual text off by default: on a laptop screen it pushes code off the right
-- edge and the message is usually truncated anyway. Float on demand instead
-- (<leader>e in keymaps.lua), which shows the whole thing.
vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  severity_sort = true,
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
  },
})

-- Briefly highlight text on yank, so you can see what you actually copied.
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
