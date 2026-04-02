return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 200,
      preset = "modern",
      spec = {
        { "<leader><tab>", group = "tabs" },
        { "<leader>b", group = "buffers" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>q", group = "quit/session" },
        { "<leader>r", group = "refactor" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "terminal/toggle" },
        { "<leader>u", group = "ui" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>z", group = "folds" },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic",
    },
    opts = function()
      local icons = require("util.icons")

      local function navic_location()
        local ok, navic = pcall(require, "nvim-navic")
        if ok and navic.is_available() then
          return navic.get_location()
        end

        return ""
      end

      return {
        options = {
          theme = "catppuccin",
          globalstatus = true,
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "alpha", "dashboard", "neo-tree" },
            winbar = { "neo-tree", "toggleterm" },
          },
        },
        sections = {
          lualine_a = { { "mode", fmt = function(str) return str:sub(1, 1) end } },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            {
              "filename",
              path = 1,
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
            },
          },
          lualine_x = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            "filetype",
            "encoding",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        winbar = {
          lualine_c = {
            {
              navic_location,
              cond = function()
                local ok, navic = pcall(require, "nvim-navic")
                return ok and navic.is_available()
              end,
            },
          },
        },
        inactive_winbar = {
          lualine_c = {
            {
              "filename",
              path = 1,
            },
          },
        },
      }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local ok, catppuccin_bufferline = pcall(require, "catppuccin.special.bufferline")
      local highlights = ok and catppuccin_bufferline.get_theme({
        styles = { "bold" },
      }) or nil

      return {
        highlights = highlights,
        options = {
          always_show_bufferline = true,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diag)
            local parts = {}
            if diag.error then
              parts[#parts + 1] = " " .. diag.error .. ""
            end
            if diag.warning then
              parts[#parts + 1] = " " .. diag.warning .. ""
            end
            return table.concat(parts)
          end,
          mode = "buffers",
          offsets = {
            {
              filetype = "neo-tree",
              text = "Explorer",
              text_align = "center",
              separator = true,
            },
          },
          separator_style = "slant",
          show_buffer_close_icons = false,
          show_close_icon = false,
        },
      }
    end,
  },
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = function()
      local ok, palette = pcall(require, "catppuccin.palettes")
      local colors = ok and palette.get_palette(vim.g.catppuccin_flavour or "mocha") or {}

      return {
        background_colour = colors.base or "#1e1e2e",
        fps = 60,
        render = "wrapped-compact",
        stages = "slide",
        timeout = 3000,
        top_down = false,
      }
    end,
    config = function(_, opts)
      local logger = require("core.logs")
      logger.wrap("notify.setup", function()
        local notify = logger.require("notify", { silent = true, context = "notify" })
        if not notify then
          return
        end

        notify.setup(opts)
        logger.set_notify_impl(notify)
      end)
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        view = "cmdline_popup",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
      },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      focus = true,
      modes = {
        symbols = {
          win = {
            position = "right",
            size = 0.28,
          },
        },
      },
      warn_no_results = false,
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        override_vim_notify = false,
        window = {
          winblend = 0,
        },
      },
    },
  },
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function()
      local animate = require("mini.animate")

      return {
        cursor = {
          enable = false,
        },
        resize = {
          timing = animate.gen_timing.cubic({ duration = 80, unit = "total" }),
        },
        open = {
          timing = animate.gen_timing.cubic({ duration = 80, unit = "total" }),
        },
        close = {
          timing = animate.gen_timing.cubic({ duration = 80, unit = "total" }),
        },
        scroll = {
          enable = false,
        },
      }
    end,
  },
}
