local opt = vim.opt

opt.spelllang = "en_us"
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.expandtab = true
opt.termguicolors = true
opt.clipboard = "unnamedplus"

opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.ignorecase = true
opt.cursorline = true
opt.expandtab = true
opt.ruler = false
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
