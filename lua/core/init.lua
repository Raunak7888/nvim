local M = {}

function M.setup()
  local logger = require("core.logs")

  for _, module in ipairs({
    "core.options",
    "core.autocmds",
    "core.lazy",
    "core.keymaps",
  }) do
    logger.require(module)
  end
end

return M
