local M = {}

M.diagnostics = {
  Error = " ",
  Warn = " ",
  Hint = "󰌵 ",
  Info = " ",
}

M.git = {
  added = "│",
  changed = "│",
  removed = "_",
}

M.kinds = {
  Array = " ",
  Boolean = "󰨙 ",
  Class = " ",
  Color = " ",
  Constant = "󰏿 ",
  Constructor = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = "󰊕 ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = "󰊕 ",
  Module = " ",
  Namespace = "󰦮 ",
  Null = " ",
  Number = "󰎠 ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Property = " ",
  Reference = " ",
  Snippet = "󱄽 ",
  String = " ",
  Struct = "󰆼 ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Value = " ",
  Variable = "󰀫 ",
}

return M
