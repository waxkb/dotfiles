require("config.lazy")

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("vim._core.ui2").enable()
require("statusline")
vim.lsp.enable("bashls")
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})
vim.lsp.enable("lua_ls")
vim.lsp.enable("ty")
vim.lsp.enable("rust_analyzer")
