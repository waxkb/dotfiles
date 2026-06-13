require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("vim._core.ui2").enable()

vim.cmd("packadd nvim.undotree")

vim.keymap.set("n", "<leader>u", "<cmd>Undotree<cr>", { desc = "Open Undotree" })
