local blink_dir = vim.env.BLINK_CMP_DIR
local friendly_snippets_dir = vim.env.FRIENDLY_SNIPPETS_DIR

local blink_opts = {
  keymap = { preset = "default" },
  sources = { default = { "lsp", "path", "snippets", "buffer" } },
  fuzzy = { implementation = "rust" },
  completion = {
    menu = { border = "single" },
    documentation = {
      auto_show = false,
      window = { border = "single" },
    },
  },
  signature = { window = { border = "single" } },
}

local spec = {
  event = "VeryLazy",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  opts = blink_opts,
  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
}

if friendly_snippets_dir and friendly_snippets_dir ~= "" then
  spec.dependencies = {
    {
      dir = friendly_snippets_dir,
      name = "friendly-snippets",
    },
  }
else
  spec.dependencies = {
    "rafamadriz/friendly-snippets",
  }
end

if blink_dir and blink_dir ~= "" then
  spec.dir = blink_dir
  spec.name = "blink.cmp"
  spec.main = "blink.cmp"
else
  spec[1] = "saghen/blink.cmp"
end

return {
  spec,
}
