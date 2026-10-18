return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = {
    formatters_by_ft = {
      bash = { "shfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
      -- java = { "google-java-format" },
      -- Prefer Spotless via Gradle when a gradlew project is present,
      -- fall back to astyle otherwise.
      -- timeout_ms is per-filetype here so manual :ConformFormat also
      -- waits long enough for a cold Gradle daemon (see format_after_save).
      java = { "spotless_gradle", "astyle", stop_after_first = true, timeout_ms = 30000 },
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
    format_after_save = function(bufnr)
      -- spotless_gradle shells out to gradlew, which needs seconds on a
      -- cold daemon (warm is <1s), not the 1s conform default.
      if vim.bo[bufnr].filetype == "java" then
        return { timeout_ms = 30000, lsp_format = "fallback" }
      end
      return { lsp_format = "fallback" }
    end,
    formatters = {
      -- Built-in spotless_gradle uses command "./gradlew", which conform
      -- checks with vim.fn.executable() relative to nvim's cwd (not the
      -- formatter cwd), so it reports "Command './gradlew' not found"
      -- and silently falls back to astyle (-s4). Resolve the absolute
      -- path so availability detection works from any cwd.
      spotless_gradle = {
        command = function(_, ctx)
          local root = vim.fs.root(ctx.dirname, { "gradlew", "gradlew.bat" })
          if root then
            if vim.fn.has("win32") == 1 then
              return root .. "/gradlew.bat"
            end
            return root .. "/gradlew"
          end
          return "./gradlew"
        end,
      },
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
