local group = vim.api.nvim_create_augroup("user_core", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight on yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 180 })
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = group,
  desc = "Reload files changed outside of Neovim",
  command = "checktime",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  desc = "Create parent directories before save",
  callback = function(event)
    local path = vim.api.nvim_buf_get_name(event.buf)
    if path == "" or path:match("^%w+://") then
      return
    end

    local dir = vim.fn.fnamemodify(path, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = group,
  desc = "Keep splits balanced",
  command = "tabdo wincmd =",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  desc = "Restore last cursor position",
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_pos_restored then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      vim.b[buf].last_pos_restored = true
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Close helper buffers with q",
  pattern = {
    "checkhealth",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  desc = "Polish prose buffers",
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.linebreak = true
    vim.opt_local.colorcolumn = ""
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  desc = "Terminal defaults",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  callback = function()
    local stats = require("lazy").stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    vim.schedule(function()
      vim.notify(
        ("Loaded %d/%d plugins in %.2f ms"):format(stats.loaded, stats.count, ms),
        vim.log.levels.INFO,
        { title = "Neovim" }
      )
    end)
  end,
})
