local fzf_build

if vim.fn.executable("cmake") == 1 then
  fzf_build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
elseif vim.fn.executable("make") == 1 then
  fzf_build = "make"
end

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({
            hidden = true,
            no_ignore = true,
          })
        end,
        desc = "Find files",
      },
      {
        "<leader>fg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Live grep",
      },
      {
        "<leader>fG",
        function()
          require("telescope.builtin").git_files({
            show_untracked = true,
          })
        end,
        desc = "Git files",
      },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Help tags",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Recent files",
      },
      {
        "<leader>fs",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "Document symbols",
      },
      {
        "<leader>fS",
        function()
          require("telescope.builtin").lsp_workspace_symbols()
        end,
        desc = "Workspace symbols",
      },
      {
        "<leader>fd",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>fw",
        function()
          require("telescope").extensions.git_worktree.git_worktrees()
        end,
        desc = "Git worktrees",
      },
      {
        "<leader>fW",
        function()
          require("telescope").extensions.git_worktree.create_git_worktree()
        end,
        desc = "Create worktree",
      },
      {
        "<leader>fu",
        function()
          require("telescope").extensions.undo.undo()
        end,
        desc = "Undo history",
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = fzf_build,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "debugloop/telescope-undo.nvim",
      "ThePrimeagen/git-worktree.nvim",
    },
    opts = function()
      local actions = require("telescope.actions")

      return {
        defaults = {
          path_display = { "smart" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.58,
            },
            vertical = {
              mirror = false,
            },
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            },
          },
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "target/",
            "build/",
            "dist/",
            ".mypy_cache/",
            ".pytest_cache/",
            ".ruff_cache/",
          },
        },
        pickers = {
          find_files = {
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob",
              "!**/.git/*",
            },
          },
        },
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown(),
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          live_grep_args = {
            auto_quoting = true,
          },
          undo = {
            side_by_side = true,
            layout_strategy = "vertical",
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "live_grep_args")
      pcall(telescope.load_extension, "undo")
      pcall(telescope.load_extension, "git_worktree")
    end,
  },
}
