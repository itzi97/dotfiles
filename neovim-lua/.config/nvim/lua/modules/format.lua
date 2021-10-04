require("formatter").setup({
  logging = false,
  filetype = {
    cpp = {
      -- clang-format
      function()
        return {
          exe = "clang-format",
          args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
          stdin = true,
          cwd = vim.fn.expand('%:p:h') -- Run clang-format in cwd of the file.
        }
      end
    },
    go = {
      -- golang
      function() return {exe = "gofmt", args = {"-s"}, stdin = true} end
    },
    javascript = {
      -- prettier
      function()
        return {
          exe = "prettier",
          args = {
            "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"
          },
          stdin = true
        }
      end
    },
    rust = {
      -- rustfmt
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout", "--edition", 2018},
          stdin = true
        }
      end
    },
    lua = {
      -- lua-format
      function()
        return {
          exe = "lua-format",
          args = {
            "--indent-width=2", "--no-use-tab", "--column-limit=80",
            "--tab-width=2"
          },
          stdin = true
        }
      end
    },
    tex = {
      -- latexindent
      function() return {exe = "latexindent", args = {""}, stdin = true} end
    }
  }
})

vim.api.nvim_exec([[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.js,*.rs,*.lua,*.tex,*.go,*.cpp,*.h,*.cxx FormatWrite
  augroup END
]], true)