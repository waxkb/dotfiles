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
      winopts = {
        preview = { default = 'bat_native' }
      },
      fzf_opts = { ['--ansi'] = false },
      files = {
        git_icons = false,
        file_icons = false,
      },
      grep = {
        rg_opts = "--column --line-number --no-heading --color=never --smart-case --max-columns=4096 -e",
      },
    },
    ---@diagnostic enable: missing-fields
    keys = {
      { "<leader>ff", function() require("fzf-lua").files({ cwd_prompt = false, prompt = '> ' }) end, desc = "Fuzzy find files" },
      { "<leader>fg", function() require("fzf-lua").grep() end, desc = "Grep files" },
      { "<leader>fl", function() require("fzf-lua").live_grep_native() end, desc = "Live grep files" },
    },
  }
}
