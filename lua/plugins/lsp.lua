return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "bash-language-server",
        "basedpyright",
        "clang-format",
        "clangd",
        "codelldb",
        "debugpy",
        "eslint_d",
        "google-java-format",
        "java-debug-adapter",
        "java-test",
        "jdtls",
        "js-debug-adapter",
        "json-lsp",
        "lua-language-server",
        "prettierd",
        "ruff",
        "shellcheck",
        "shfmt",
        "stylua",
        "typescript-language-server",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 12,
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local lspconfig_util = require("lspconfig.util")
      local schemastore = require("schemastore")
      local lsp = require("util.lsp")

      lsp.setup()

      mason_lspconfig.setup({
        ensure_installed = {
          "bashls",
          "basedpyright",
          "clangd",
          "jsonls",
          "lua_ls",
          "ts_ls",
        },
        automatic_installation = true,
      })

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
              hint = {
                enable = true,
              },
              runtime = {
                version = "LuaJIT",
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                  callArgumentNames = true,
                  functionReturnTypes = true,
                  pytestParameters = true,
                  variableTypes = true,
                },
                typeCheckingMode = "standard",
              },
            },
          },
        },
        ts_ls = {
          single_file_support = false,
          root_dir = lspconfig_util.root_pattern(
            "tsconfig.json",
            "jsconfig.json",
            "package.json",
            ".git"
          ),
          init_options = {
            hostInfo = "neovim",
            preferences = {
              includeCompletionsForImportStatements = true,
              includeCompletionsForModuleExports = true,
            },
          },
        },
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--fallback-style=llvm",
            "--function-arg-placeholders",
            "--header-insertion=iwyu",
          },
          root_dir = lspconfig_util.root_pattern(
            "compile_commands.json",
            "compile_flags.txt",
            ".clangd",
            ".git"
          ),
        },
        bashls = {},
        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
              schemas = schemastore.json.schemas(),
            },
          },
        },
      }

      for server, opts in pairs(servers) do
        opts.capabilities = vim.tbl_deep_extend("force", {}, lsp.capabilities, opts.capabilities or {})
        opts.on_attach = opts.on_attach or lsp.on_attach
        lspconfig[server].setup(opts)
      end
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
}
