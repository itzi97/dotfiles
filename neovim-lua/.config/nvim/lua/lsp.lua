-- Load Lua plugins.
vim.cmd [[packadd nvim-lspconfig]]
vim.cmd [[packadd diagnostic-nvim]]
local nvim_lsp = require("nvim_lsp")
local diagnostic = require("diagnostic")

local texlab_build_status = vim.tbl_add_reverse_lookup {
  Success = 0,
  Error = 1,
  Failure = 2,
  Cancelled = 3
}

local function buf_build(bufnr)
  bufnr = require("nvim_lsp/util").validate_bufnr(bufnr)
  local params = {textDocument = {uri = vim.uri_from_bufnr(bufnr)}}
  vim.lsp.buf_request(bufnr, "textDocument/build", params, function(err, _, result, _)
    if err then
      error(tostring(err))
    end
    print("Build " .. texlab_build_status[result.status])
  end)
end

local function make_on_attach(config)
  return function(client)
    if config.before then
      config.before(client)
    end

    diagnostic.on_attach()

    local mapper = function(mode, key, result)
      vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap = true, silent = true})
    end

    mapper("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
    mapper("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
    mapper("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
    mapper("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
    mapper("n", "<c-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
    mapper("n", "gTD", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
    mapper("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
    mapper("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
    mapper("n", "gA", "<cmd>lua vim.lsp.buf.code_action()<CR>")
    mapper("n", "<leader>e", "<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>")
    mapper("n", "]e", "<cmd>NextDiagnosticCycle<cr>")
    mapper("n", "[e", "<cmd>PrevDiagnosticCycle<cr>")

    if client.resolved_capabilities.document_formatting then
      mapper("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>")
    end

    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_command("augroup lsp_aucmds")
      vim.api.nvim_command("au CursorHold <buffer> lua vim.lsp.buf.document_highlight()")
      vim.api.nvim_command("au CursorMoved <buffer> lua vim.lsp.buf.clear_references()")
      vim.api.nvim_command("augroup END")
    end

    if config.after then
      config.after(client)
    end
  end
end

local servers = {

  -- Bash
  bashls = {filetypes = {"sh", "zsh", "bash"}},

  -- C/C++
  ccls = {},
  clangd = {
    cmd = {
      "clangd",
      "--clang-tidy",
      "--completion-style=bundled",
      "--header-insertion=iwyu",
      "--suggest-missing-includes",
      "--cross-file-rename"
    },
    init_options = {
      clangdFileStatus = true,
      usePlaceholders = true,
      completeUnimported = true,
      semanticHighlighting = true
    }
  },

  -- CMake
  cmake = {},

  -- Diagnostics
  diagnosticls = {filetypes = {"sh", "zsh", "md", "plain", "latex"}},

  -- CSS
  cssls = {},

  -- Go
  gopls = {},

  -- Haskell
  ghcide = {},
  hls = {},

  -- Html
  html = {},

  -- Java
  jdtls = {},

  -- JavaScript
  flow = {},
  tsserver = {},

  -- Julia
  julials = {},

  -- TODO LaTeX
  texlab = {},
  -- texlab = {
  --  default_config = {
  --    cmd = {"texlab"},
  --    filetypes = {"tex", "bib"},
  --    root_dir = vim.loop.os_homedir,
  --    settings = {
  --      latex = {
  --        build = {
  --          args = {"-pdf", "-interaction=nonstopmode", "-synctex=1"},
  --          executable = "latexmk",
  --          onSave = false
  --        },
  --        forwardSearch = {args = {}, executable = nil, onSave = false},
  --        lint = {onChange = true}
  --      },
  --      bibtex = {formatting = {lineLength = 120}}
  --    }
  --  },
  --  commands = {
  --    TexlabBuild = {
  --      function()
  --        buf_build(0)
  --      end,
  --      description = "Build the current buffer"
  --    }
  --  },
  --  docs = {
  --    description = [[
  --      https://texlab.netlify.com/
  --      A completion engine built from scratch for (La)TeX.
  --      See https://texlab.netlify.com/docs/reference/configuration for configuration options.
  --    ]],
  --    default_config = {root_dir = "vim's starting directory"}
  --  }
  -- },

  -- Lua
  sumneko_lua = {
    cmd = {"lua-language-server"},
    settings = {
      Lua = {
        diagnostics = {globals = {"vim"}},
        completion = {keywordSnippet = "Enable"},
        runtime = {version = "LuaJIT", path = vim.split(package.path, ";")},
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
          }
        }
      }
    }
  },

  -- Nix
  rnix = {},

  -- PHP
  intelephense = {},

  -- Python
  pyls = {},

  -- R
  r_language_server = {},

  -- Rust
  rls = {},
  rust_analyzer = {},

  -- SQL
  sqlls = {},

  -- Vim
  vimls = {},

  -- Vue
  vuels = {}
}

local snippet_capabilities = {
  textDocument = {completion = {completionItem = {snippetSupport = true}}}
}

local function deep_extend(policy, ...)
  local result = {}
  local function helper(policy, k, v1, v2)
    if type(v1) ~= "table" or type(v2) ~= "table" then
      if policy == "error" then
        error("Key " .. vim.inspect(k) .. " is already present with value " .. vim.inspect(v1))
      elseif policy == "force" then
        return v2
      else
        return v1
      end
    else
      return deep_extend(policy, v1, v2)
    end
  end

  for _, t in ipairs({...}) do
    for k, v in pairs(t) do
      if result[k] ~= nil then
        result[k] = helper(policy, k, result[k], v)
      else
        result[k] = v
      end
    end
  end

  return result
end

for server, config in pairs(servers) do
  config.on_attach = make_on_attach(config)
  config.capabilities = deep_extend("keep", config.capabilities or {}, snippet_capabilities)

  nvim_lsp[server].setup(config)
end
