local M = {}

local icons = require("util.icons")

M.capabilities = vim.tbl_deep_extend(
  "force",
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

function M.setup()
  for severity, icon in pairs(icons.diagnostics) do
    local hl = "DiagnosticSign" .. severity
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

function M.on_attach(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = bufnr,
      silent = true,
      desc = desc,
    })
  end

  if client.name == "ts_ls" or client.name == "jsonls" then
    client.server_capabilities.documentFormattingProvider = false
  end

  map("n", "gd", function()
    require("telescope.builtin").lsp_definitions()
  end, "Goto definition")
  map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  map("n", "gr", function()
    require("telescope.builtin").lsp_references()
  end, "References")
  map("n", "gI", function()
    require("telescope.builtin").lsp_implementations()
  end, "Goto implementation")
  map("n", "gy", function()
    require("telescope.builtin").lsp_type_definitions()
  end, "Goto type definition")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
  map("n", "<leader>cA", function()
    vim.lsp.buf.code_action({
      context = {
        only = { "source" },
        diagnostics = {},
      },
      apply = true,
    })
  end, "Source action")
  map("n", "<leader>cl", "<cmd>LspInfo<cr>", "LSP info")
  map("n", "<leader>cf", function()
    require("conform").format({
      bufnr = bufnr,
      async = true,
      lsp_format = "fallback",
    })
  end, "Format buffer")

  if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
    map("n", "<leader>uh", function()
      local enabled = false

      if vim.lsp.inlay_hint.is_enabled then
        local ok, value = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
        if ok then
          enabled = value
        else
          ok, value = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
          if ok then
            enabled = value
          end
        end
      end

      vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
    end, "Toggle inlay hints")
  end
end

return M
