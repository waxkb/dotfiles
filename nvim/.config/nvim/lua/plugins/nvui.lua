return {
  {
    "nvchad/ui",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvchad")
    end,
  },
}
