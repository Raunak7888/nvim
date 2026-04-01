local M = {}

M.markers = {
  ".git",
  "gradlew",
  "mvnw",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
  "package.json",
  "tsconfig.json",
  "jsconfig.json",
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "compile_commands.json",
  ".clangd",
}

function M.get(bufnr)
  local buffer = bufnr or 0
  local path = vim.api.nvim_buf_get_name(buffer)
  if path == "" then
    return vim.uv.cwd()
  end

  return vim.fs.root(path, M.markers) or vim.uv.cwd()
end

return M
