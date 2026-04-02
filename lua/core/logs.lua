local M = {}

local default_notify = vim.notify
local notify_impl = default_notify
local levels = vim.log.levels

M.log_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "logs")
M.log_file = vim.fs.joinpath(M.log_dir, "errors.log")

local function normalize_message(message)
  if type(message) == "table" then
    return vim.inspect(message)
  end

  return tostring(message)
end

local function level_name(level)
  for name, value in pairs(levels) do
    if value == level then
      return name
    end
  end

  return tostring(level or levels.INFO)
end

function M.ensure()
  vim.fn.mkdir(M.log_dir, "p")

  if vim.fn.filereadable(M.log_file) == 0 then
    vim.fn.writefile({}, M.log_file)
  end

  return M.log_file
end

function M.write(level, message, opts)
  opts = opts or {}

  local lines = {
    string.rep("=", 96),
    ("[%s] [%s]%s"):format(
      os.date("%Y-%m-%d %H:%M:%S"),
      level_name(level),
      opts.context and (" [" .. opts.context .. "]") or ""
    ),
  }

  if opts.title and opts.title ~= "" then
    lines[#lines + 1] = ("Title: %s"):format(opts.title)
  end

  lines[#lines + 1] = normalize_message(message)

  if opts.traceback and opts.traceback ~= "" then
    lines[#lines + 1] = "Traceback:"
    vim.list_extend(lines, vim.split(opts.traceback, "\n", { plain = true }))
  end

  lines[#lines + 1] = ""

  vim.fn.writefile(lines, M.ensure(), "a")
end

function M.log(level, message, opts)
  M.write(level or levels.ERROR, message, opts)
end

function M.notify(message, level, opts)
  local actual_level = level or levels.INFO

  if actual_level >= levels.ERROR then
    M.write(actual_level, message, {
      title = opts and opts.title or "",
      context = opts and opts.context or "vim.notify",
      traceback = opts and opts.traceback or debug.traceback("", 2),
    })
  end

  return notify_impl(message, actual_level, opts)
end

function M.set_notify_impl(fn)
  notify_impl = fn or default_notify
  vim.notify = M.notify
end

function M.require(module_name, opts)
  opts = opts or {}

  local ok, result = xpcall(function()
    return require(module_name)
  end, function(err)
    return debug.traceback(normalize_message(err), 2)
  end)

  if ok then
    return result
  end

  M.write(levels.ERROR, ("Failed to require %s"):format(module_name), {
    context = opts.context or module_name,
    traceback = result,
  })

  if not opts.silent then
    vim.schedule(function()
      M.notify(("Failed to load %s"):format(module_name), levels.ERROR, {
        title = "Neovim config",
        context = opts.context or module_name,
      })
    end)
  end

  return nil
end

function M.wrap(context, fn, ...)
  local args = { ... }

  return xpcall(function()
    return fn(unpack(args))
  end, function(err)
    local message = normalize_message(err)
    M.write(levels.ERROR, message, {
      context = context,
      traceback = debug.traceback(message, 2),
    })

    vim.schedule(function()
      M.notify(message, levels.ERROR, {
        title = context,
        context = context,
      })
    end)

    return err
  end)
end

function M.safe_setup(module_name, opts, context)
  local module = M.require(module_name, {
    silent = true,
    context = context or module_name,
  })

  if not module or type(module.setup) ~= "function" then
    return false
  end

  local ok = M.wrap(context or (module_name .. ".setup"), function()
    module.setup(opts or {})
  end)

  return ok
end

function M.open()
  local path = M.ensure()
  vim.cmd("botright split")
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

function M.clear()
  vim.fn.writefile({}, M.ensure())
  M.notify("Cleared Neovim error log", levels.INFO, { title = "Logger" })
end

function M.setup()
  M.ensure()
  M.set_notify_impl(default_notify)

  _G.error_logger = M
  vim.g.error_logger = {
    path = M.log_file,
    edit_command = "EditErrorLog",
    clear_command = "ClearErrorLog",
  }

  vim.api.nvim_create_user_command("EditErrorLog", function()
    M.open()
  end, { desc = "Open the Neovim error log" })

  vim.api.nvim_create_user_command("ClearErrorLog", function()
    M.clear()
  end, { desc = "Clear the Neovim error log" })
end

return M
