-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.relativenumber = true

---- Safely source matugen-generated colors
--local function source_matugen()
--  local matugen_path = vim.fn.stdpath("config") .. "/generated.lua"
--
--  vim.schedule(function()
--    local ok, err = pcall(dofile, matugen_path)
--    if not ok then
--      -- Fallback colorscheme if matugen file is unavailable
--      vim.cmd("colorscheme base16-catppuccin-mocha")
--
--      -- Optional debug message (comment out once stable)
--      vim.notify("Matugen file not loaded:\n" .. err, vim.log.levels.WARN)
--    end
--  end)
--end
--
---- Main entrypoint on matugen reloads
--local function auxiliary_function()
--  vim.schedule(function()
--    -- Reload matugen colors
--    source_matugen()
--
--    -- Reload lualine after base16 changes
--    pcall(dofile, vim.fn.stdpath("config") .. "/config/plugins/lualine-nvim.lua")
--
--    -- Any extra tweaks you want after reload
--    vim.api.nvim_set_hl(0, "Comment", { italic = true })
--  end)
--end
--
---- Apply matugen colors once Neovim has fully started
--vim.api.nvim_create_autocmd("VimEnter", {
--  callback = source_matugen,
--})
--
---- Register an autocmd to listen for matugen updates
--vim.api.nvim_create_autocmd("Signal", {
--  pattern = "SIGUSR1",
--  callback = auxiliary_function,
--})


require("luasnip").config.set_config({ -- Setting LuaSnip config

  -- Enable autotriggered snippets
  enable_autosnippets = true,

  -- Use Tab (or some other key if you prefer) to trigger visual selection
  store_selection_keys = "<Tab>",
})


vim.cmd[[
   " Expand or jump in insert mode
    imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 

    " Jump forward through tabstops in visual mode
    smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'
    imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
    smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]]


require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/LuaSnip/"})
