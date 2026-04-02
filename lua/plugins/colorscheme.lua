return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      local logger = require("core.logs")

      local function theme_opts(flavour)
        return {
          flavour = flavour,
          background = {
            light = "latte",
            dark = flavour,
          },
          compile_path = vim.fs.joinpath(vim.fn.stdpath("cache"), "catppuccin"),
          term_colors = true,
          show_end_of_buffer = false,
          transparent_background = false,
          dim_inactive = {
            enabled = true,
            shade = "dark",
            percentage = 0.12,
          },
          float = {
            transparent = false,
            solid = false,
          },
          styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            keywords = { "italic" },
          },
          lsp_styles = {
            virtual_text = {
              hints = { "italic" },
              information = { "italic" },
              warnings = { "italic" },
            },
            inlay_hints = {
              background = true,
            },
          },
          default_integrations = false,
          integrations = {
            cmp = true,
            dap = true,
            dap_ui = true,
            fidget = true,
            gitsigns = true,
            mason = true,
            mini = true,
            native_lsp = {
              enabled = true,
              inlay_hints = {
                background = true,
              },
              underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
              },
            },
            neotree = true,
            noice = true,
            notify = true,
            telescope = {
              enabled = true,
            },
            treesitter = true,
            which_key = true,
          },
          highlight_overrides = {
            all = function(colors)
              return {
                CursorLineNr = { fg = colors.lavender, style = { "bold" } },
                FloatBorder = { fg = colors.surface2 },
                FloatTitle = { fg = colors.blue, style = { "bold" } },
                NormalFloat = { bg = colors.mantle },
                Pmenu = { bg = colors.mantle },
                PmenuSel = { bg = colors.surface1, fg = colors.text },
                Search = { bg = colors.surface2, fg = colors.text },
                IncSearch = { bg = colors.peach, fg = colors.base },
                TelescopeBorder = { fg = colors.surface2, bg = colors.mantle },
                TelescopePromptBorder = { fg = colors.surface2, bg = colors.mantle },
                TelescopePreviewBorder = { fg = colors.surface2, bg = colors.mantle },
                TelescopeResultsBorder = { fg = colors.surface2, bg = colors.mantle },
                WinSeparator = { fg = colors.surface1 },
              }
            end,
          },
        }
      end

      local function apply(flavour)
        vim.g.catppuccin_flavour = flavour

        logger.wrap("catppuccin.setup", function()
          local catppuccin = logger.require("catppuccin", { silent = true, context = "catppuccin" })
          if not catppuccin then
            return
          end

          catppuccin.setup(theme_opts(flavour))
          vim.cmd.colorscheme("catppuccin")
        end)
      end

      apply(vim.g.catppuccin_flavour or "mocha")

      vim.api.nvim_create_user_command("CatppuccinFlavour", function(command)
        local flavour = command.args ~= "" and command.args or "mocha"
        if not vim.tbl_contains({ "latte", "frappe", "macchiato", "mocha" }, flavour) then
          vim.notify(("Unknown Catppuccin flavour: %s"):format(flavour), vim.log.levels.ERROR, {
            title = "Theme",
          })
          return
        end

        apply(flavour)
      end, {
        desc = "Switch Catppuccin flavour",
        nargs = "?",
        complete = function()
          return { "latte", "frappe", "macchiato", "mocha" }
        end,
      })
    end,
  },
}
