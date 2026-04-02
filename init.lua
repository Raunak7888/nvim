vim.g.mapleader = vim.g.mapleader or " "
vim.g.maplocalleader = vim.g.maplocalleader or "\\"
vim.g.catppuccin_flavour = vim.g.catppuccin_flavour or "mocha"

local logger = require("core.logs")
logger.setup()
logger.wrap("core.bootstrap", function()
  require("core").setup()
end)
