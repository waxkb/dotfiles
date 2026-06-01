local opt = vim.opt

opt.spelllang = "en_us"
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.termguicolors = true
opt.clipboard = "unnamedplus"

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ", -- This is the line that hides the tildes
}

-- vim.g.vimtex_compiler_latexmk = {
-- 	continuous = 0,
-- }
