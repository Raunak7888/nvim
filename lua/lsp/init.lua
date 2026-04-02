local M = {}

local logger = require("core.logs")
local icons = require("util.icons")

local function make_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")

  if cmp_ok then
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
  end

  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return capabilities
end

M.capabilities = make_capabilities()

local formatting_disabled = {
  clangd = true,
  jdtls = true,
  jsonls = true,
  lua_ls = true,
  ts_ls = true,
}

local function map(bufnr, mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, {
    buffer = bufnr,
    silent = true,
    desc = desc,
  })
end

local function attach_navic(client, bufnr)
  if not client.server_capabilities.documentSymbolProvider then
    return
  end

  local navic = logger.require("nvim-navic", { silent = true, context = "lsp.navic" })
  if navic then
    navic.attach(client, bufnr)
  end
end

local function attach_java(client, bufnr)
  if client.name ~= "jdtls" or vim.b[bufnr].jdtls_ready then
    return
  end

  vim.b[bufnr].jdtls_ready = true

  local jdtls = logger.require("jdtls", { silent = true, context = "lsp.jdtls" })
  if not jdtls then
    return
  end

  logger.wrap("jdtls.attach", function()
    jdtls.setup_dap({ hotcodereplace = "auto" })
    jdtls.dap.setup_dap_main_class_configs()
    require("jdtls.setup").add_commands()
  end)
end

local function setup_document_highlight(client, bufnr)
  if not client.server_capabilities.documentHighlightProvider then
    return
  end

  local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

function M.on_attach(client, bufnr)
  if formatting_disabled[client.name] then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  map(bufnr, "n", "gd", function()
    require("telescope.builtin").lsp_definitions()
  end, "Goto definition")
  map(bufnr, "n", "gD", vim.lsp.buf.declaration, "Goto declaration")
  map(bufnr, "n", "gr", function()
    require("telescope.builtin").lsp_references()
  end, "References")
  map(bufnr, "n", "gI", function()
    require("telescope.builtin").lsp_implementations()
  end, "Goto implementation")
  map(bufnr, "n", "gy", function()
    require("telescope.builtin").lsp_type_definitions()
  end, "Goto type definition")
  map(bufnr, "n", "K", vim.lsp.buf.hover, "Hover")
  map(bufnr, "n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  map(bufnr, { "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map(bufnr, "n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
  map(bufnr, "n", "<leader>cA", function()
    vim.lsp.buf.code_action({
      context = {
        only = { "source" },
        diagnostics = {},
      },
      apply = true,
    })
  end, "Source action")
  map(bufnr, "n", "<leader>cf", function()
    local conform = logger.require("conform", { silent = true, context = "lsp.format" })
    if conform then
      conform.format({
        bufnr = bufnr,
        async = true,
        lsp_format = "fallback",
      })
    else
      vim.lsp.buf.format({ async = true })
    end
  end, "Format buffer")
  map(bufnr, "n", "<leader>cH", "<cmd>checkhealth vim.lsp<cr>", "LSP health")
  map(bufnr, "n", "<leader>cR", "<cmd>lsp restart<cr>", "Restart LSP")

  if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
    map(bufnr, "n", "<leader>uh", function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
    end, "Toggle inlay hints")
  end

  attach_navic(client, bufnr)
  attach_java(client, bufnr)
  setup_document_highlight(client, bufnr)
end

function M.setup()
  for severity, icon in pairs(icons.diagnostics) do
    local hl = "DiagnosticSign" .. severity
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  vim.lsp.config("*", {
    capabilities = M.capabilities,
    root_markers = { ".git" },
  })

  local group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client then
        M.on_attach(client, event.buf)
      end
    end,
  })

  for _, server in ipairs({
    "bashls",
    "basedpyright",
    "clangd",
    "jsonls",
    "lua_ls",
    "ts_ls",
  }) do
    vim.lsp.enable(server)
  end
end

return M
