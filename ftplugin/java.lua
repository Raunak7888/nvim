local java = require("lsp.java")
local root_dir = vim.fs.root(0, java.root_markers)

if not root_dir then
  return
end

vim.lsp.config("jdtls", {
  cmd = java.command(root_dir),
  root_dir = root_dir,
})

vim.lsp.enable("jdtls")
