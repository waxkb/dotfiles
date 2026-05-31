return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      bash = { "shfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      -- java = { "google-java-format" },
      java = { "astyle" },
      lua = { "stylua" },
      nix = { "nixfmt" },
      python = { "ruff_format" },
      rust = { "rustfmt" },
      zsh = { "shfmt" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters = {
      shfmt = {
        command = "/run/current-system/sw/bin/shfmt",
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
