return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local langs = {
        "bash",
        "c",
        "cpp",
        "diff",
        "ini",
        "java",
        "json",
        "julia",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      }
      require("nvim-treesitter").setup({})
      -- Neovim 0.11+ already ships these; installing them via
      -- nvim-treesitter just forces a redundant cc build.
      local bundled = { c = true, lua = true, markdown = true, markdown_inline = true, query = true, vim = true, vimdoc = true }
      local to_install = {}
      for _, lang in ipairs(langs) do
        if not bundled[lang] and #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", true) == 0 then
          table.insert(to_install, lang)
        end
      end
      if #to_install > 0 then
        -- async, no error spam on startup if cc is missing
        pcall(require("nvim-treesitter").install, to_install)
      end
      -- main branch does NOT auto-enable highlights; do it per FileType
      vim.api.nvim_create_autocmd("FileType", {
        pattern = langs,
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },
}
