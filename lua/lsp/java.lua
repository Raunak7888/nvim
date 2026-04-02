local M = {}

M.root_markers = {
  ".git",
  "gradlew",
  "mvnw",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  "settings.gradle",
  "settings.gradle.kts",
}

local function mason_package(name)
  return vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", name)
end

local function find_launcher()
  local matches = vim.fn.glob(
    vim.fs.joinpath(mason_package("jdtls"), "plugins", "org.eclipse.equinox.launcher_*.jar"),
    true,
    true
  )

  return matches[1]
end

local function os_config_dir()
  if vim.fn.has("win32") == 1 then
    return "config_win"
  end

  if vim.fn.has("mac") == 1 then
    return "config_mac"
  end

  return "config_linux"
end

local function workspace_dir(root_dir)
  local project_name = vim.fs.basename(root_dir)
  return vim.fs.joinpath(vim.fn.stdpath("data"), "jdtls-workspace", project_name)
end

function M.command(root_dir)
  local launcher = find_launcher()
  if not launcher then
    vim.notify("JDTLS launcher jar not found. Run :MasonInstall jdtls", vim.log.levels.ERROR)
    return { "jdtls" }
  end

  local lombok = vim.fs.joinpath(mason_package("jdtls"), "lombok.jar")
  local cmd = {
    "jdtls",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
  }

  if vim.uv.fs_stat(lombok) then
    table.insert(cmd, "-javaagent:" .. lombok)
  end

  vim.list_extend(cmd, {
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    launcher,
    "-configuration",
    vim.fs.joinpath(mason_package("jdtls"), os_config_dir()),
    "-data",
    workspace_dir(root_dir),
  })

  return cmd
end

function M.bundles()
  local bundles = {}
  local java_debug = vim.fn.glob(
    vim.fs.joinpath(
      mason_package("java-debug-adapter"),
      "extension",
      "server",
      "com.microsoft.java.debug.plugin-*.jar"
    ),
    true,
    true
  )
  local java_test = vim.fn.glob(
    vim.fs.joinpath(mason_package("java-test"), "extension", "server", "*.jar"),
    true,
    true
  )

  vim.list_extend(bundles, java_debug)
  vim.list_extend(bundles, java_test)

  return bundles
end

function M.init_options()
  local ok, jdtls = pcall(require, "jdtls")
  if not ok then
    return {
      bundles = M.bundles(),
    }
  end

  local extended = vim.deepcopy(jdtls.extendedClientCapabilities)
  extended.resolveAdditionalTextEditsSupport = true

  return {
    bundles = M.bundles(),
    extendedClientCapabilities = extended,
  }
end

return M
