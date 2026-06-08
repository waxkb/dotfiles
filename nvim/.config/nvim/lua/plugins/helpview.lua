return {
  {
    "OXY2DEV/helpview.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-mini/mini.icons",
    },
    opts = {
      preview = {
        icon_provider = "mini",
      },
    },
    config = function(_, opts)
      require("helpview").setup(opts)
      require("helpview.highlights").setup()
    end,
  },
}
