return {
  settings = {
    basedpyright = {
      analysis = {
        autoImportCompletions = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",
        inlayHints = {
          callArgumentNames = true,
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
        },
      },
    },
  },
}
