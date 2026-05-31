return {
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {
      "ivy",
      -- fzf_bin = "sk",
      winopts = {
        -- row = 1,
        -- col = 0,
        -- width = 1,
        -- height = 0.4,
        -- title_pos = "left",
        -- border = { "", "─", "", "", "", "", "", "" },
        preview = {
          hidden = false,
          -- default = 'bat_native',
          -- layout = "horizontal",
          -- horizontal = "right:50%",
        },
        treesitter = false,
      },
      fzf_opts = {
        ['--ansi'] = false,
        -- ['--no-scrollbar'] = true,
        -- ["--info"] = false,
      },
      -- fzf_colors = {
      --   ["separator"] = "white",
      -- },
      files = {
        fzf_opts = { ["--ansi"] = false },
        git_icons = false,
        file_icons = false,
      },
      grep = {
        fzf_opts  = { ["--ansi"] = false },
        rg_opts = "--column --line-number --no-heading --color=never --smart-case --max-columns=4096 -e",
      },
      manpages = { previewer = "man_native" },
      helptags = { previewer = "help_native" },
      defaults = { git_icons = false, file_icons = false },
      lsp = { code_actions = { previewer = "codeaction_native" } },
      tags = { previewer = "bat_native" },
      btags = { previewer = "bat_native" },
    },
    ---@diagnostic enable: missing-fields
    keys = {
      { "<leader>ff", function() require("fzf-lua").files({ cwd_prompt = false, prompt = '> ' }) end, desc = "Fuzzy find files" },
      { "<leader>fg", function() require("fzf-lua").grep() end, desc = "Grep files" },
      { "<leader>fl", function() require("fzf-lua").live_grep_native() end, desc = "Live grep files" },
    },
  }
}
