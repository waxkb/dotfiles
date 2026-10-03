require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Experimental new UI (Neovim 0.12+). Guarded so stable releases
-- such as the one from winget simply skip it.
pcall(function()
  require("vim._core.ui2").enable()
end)

-- Bundled undotree viewer (Neovim 0.12+). Guarded for the same reason.
pcall(vim.cmd, "packadd nvim.undotree")

if vim.fn.exists(":Undotree") == 2 then
  vim.keymap.set("n", "<leader>u", "<cmd>Undotree<cr>", { desc = "Open Undotree" })
end
