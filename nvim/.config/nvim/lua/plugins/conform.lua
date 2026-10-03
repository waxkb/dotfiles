return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = {
    formatters_by_ft = {
      bash = { "shfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      -- java = { "google-java-format" },
      java = { "astyle" },
      lua = { "stylua" },
      -- nixfmt only exists where Nix exists (never on Windows)
      nix = vim.fn.has("win32") == 0 and { "nixfmt" } or {},
      python = { "ruff_format" },
      rust = { "rustfmt" },
      zsh = { "shfmt" },
      tex = { "latexindent" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_after_save = {
      lsp_format = "fallback",
    },
    formatters = {
      -- Resolve shfmt from PATH so this works on NixOS, other
      -- Linux distros, macOS and Windows (see windows-install.ps1).
      shfmt = {
        prepend_args = { "-i", "2" },
      },
      astyle = {
        prepend_args = { "-s4" },
      },
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
    },
  },
}
