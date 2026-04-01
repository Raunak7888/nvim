return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug step over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug step into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug step out",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Conditional breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step out",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step over",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "REPL",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "DAP UI",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "mxsdev/nvim-dap-vscode-js",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local registry = require("mason-registry")

      require("mason-nvim-dap").setup({
        ensure_installed = { "python", "codelldb" },
        automatic_installation = true,
      })

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.45 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks", size = 0.2 },
              { id = "watches", size = 0.2 },
            },
            position = "left",
            size = 48,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 12,
          },
        },
      })

      require("nvim-dap-virtual-text").setup({})

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      local mason_path = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages")
      local debugpy_python = vim.fs.joinpath(mason_path, "debugpy", "venv", "Scripts", "python.exe")
      require("dap-python").setup(debugpy_python)

      local codelldb_path = vim.fs.joinpath(mason_path, "codelldb", "extension", "adapter", "codelldb.exe")
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
          detached = false,
        },
      }

      for _, language in ipairs({ "c", "cpp" }) do
        dap.configurations[language] = {
          {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "\\", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
          },
          {
            name = "Attach to process",
            type = "codelldb",
            request = "attach",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      if registry.has_package("js-debug-adapter") then
        local debugger_path = registry.get_package("js-debug-adapter"):get_install_path()
        require("dap-vscode-js").setup({
          debugger_path = debugger_path,
          adapters = { "pwa-node", "node-terminal", "pwa-chrome", "pwa-msedge", "pwa-extensionHost" },
        })

        for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch current file",
              cwd = "${workspaceFolder}",
              runtimeExecutable = "node",
              program = "${file}",
              sourceMaps = true,
              protocol = "inspector",
              console = "integratedTerminal",
              skipFiles = { "<node_internals>/**", "**/node_modules/**" },
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach to process",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
              sourceMaps = true,
              skipFiles = { "<node_internals>/**", "**/node_modules/**" },
            },
          }
        end
      end
    end,
  },
}
