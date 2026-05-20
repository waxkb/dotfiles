return {
  {
      'nvim-telescope/telescope.nvim', version = '*',
      event = "VeryLazy",
      dependencies = {
          'nvim-lua/plenary.nvim',
          'BurntSushi/ripgrep',
          'sharkdp/fd',
          'nvim-tree/nvim-web-devicons',
          -- optional but recommended
          { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
      keys = {
          { "<leader>fx", function() require("telescope.builtin").find_files() end, desc = "Telescope find files" },
          { "<leader>fy", function() require("telescope.builtin").grep_string() end, desc = "Telescope grep files" },
          { "<leader>fz", function() require("telescope.builtin").live_grep() end, desc = "Telescope live grep files" },
      },
  }
}
