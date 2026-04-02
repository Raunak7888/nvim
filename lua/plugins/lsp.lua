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
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "b0o/SchemaStore.nvim",
      "SmiteshP/nvim-navic",
    },
    config = function()
      local logger = require("core.logs")
      logger.wrap("lsp.setup", function()
        require("nvim-navic").setup({
          depth_limit = 5,
          highlight = true,
          lazy_update_context = true,
          separator = " 󰁔 ",
        })

        require("lsp").setup()
      end)
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
}
