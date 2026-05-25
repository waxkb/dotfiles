return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            bash = { "shfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            java = { "google-java-format" },
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
                prepend_args = { "-i", "2" }, -- ⚠️ Changed from append_args
            },
        },
    },
}
