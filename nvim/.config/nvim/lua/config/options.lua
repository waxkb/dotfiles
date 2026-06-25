local opt = vim.opt

opt.spelllang = "en_us"
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
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
opt.undodir = vim.fn.expand("~/.local/state/nvim/undo")

opt.updatetime = 200
opt.virtualedit = "block"

vim.diagnostic.config({
  severity_sort = true,
})

local severity = vim.diagnostic.severity

vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = "●", -- Replace with your preferred error icon
      [severity.WARN] = "●", -- Replace with your preferred warning icon
      [severity.INFO] = "●", -- Replace with your preferred info icon
      [severity.HINT] = "●", -- Replace with your preferred hint icon
    },
  },
})
