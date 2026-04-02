local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

map("n", ";", ":", { desc = "Command mode" })
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })

map("n", "<Esc>", function()
  vim.cmd("nohlsearch")
  return "<Esc>"
end, { expr = true, desc = "Clear search highlight" })

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<leader>-", "<C-w>s", { desc = "Split below" })
map("n", "<leader>|", "<C-w>v", { desc = "Split right" })
map("n", "<leader>wd", "<C-w>c", { desc = "Delete window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Only window" })
map("n", "<leader>w=", "<C-w>=", { desc = "Balance windows" })
map("n", "<leader>wm", "<C-w>T", { desc = "Move window to tab" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>buffer #<cr>", { desc = "Last buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete other buffers" })

map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map("n", "]e", function()
  vim.diagnostic.jump({
    count = 1,
    severity = vim.diagnostic.severity.ERROR,
    float = true,
  })
end, { desc = "Next error" })
map("n", "[e", function()
  vim.diagnostic.jump({
    count = -1,
    severity = vim.diagnostic.severity.ERROR,
    float = true,
  })
end, { desc = "Previous error" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer diagnostics" })
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })

map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>h", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Only tab" })

map("n", "<leader>un", function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = vim.wo.number
end, { desc = "Toggle line numbers" })

map("n", "<leader>ur", function()
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative numbers" })

map("n", "<leader>ul", function()
  vim.opt_local.list = not vim.opt_local.list:get()
end, { desc = "Toggle listchars" })

map("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })

map("n", "<leader>us", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
end, { desc = "Toggle spell" })

map("n", "<leader>zR", function()
  vim.cmd("normal! zR")
end, { desc = "Open all folds" })

map("n", "<leader>zM", function()
  vim.cmd("normal! zM")
end, { desc = "Close all folds" })

map("n", "<leader>za", function()
  vim.cmd("normal! za")
end, { desc = "Toggle fold" })
