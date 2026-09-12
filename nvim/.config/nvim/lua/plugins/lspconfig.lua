return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    -- lazy = false,
    config = function()
      vim.lsp.enable("bashls")
      vim.lsp.config("jdtls", {
        cmd = { "jdtls", "-data", vim.fn.stdpath("data") .. "/jdtls/workspace" },
      })
      vim.lsp.enable("jdtls")
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
    end,
  },
}
