return {
  {
    name = "custom-statusline",
    dir = vim.fn.stdpath("config") .. "/lua/custom/statusline",
    event = "VeryLazy",
    dependencies = {
      "AvengeMedia/base46",
    },
    config = function()
      require("custom.statusline")
    end,
  },
}
