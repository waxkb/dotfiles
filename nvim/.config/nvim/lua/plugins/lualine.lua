return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "AvengeMedia/base46",
    },
    opts = {
      options = {
        disabled_filetypes = {
          statusline = { "snacks_dashboard" },
          winbar = {},
        },
      },
    },
  },
}
