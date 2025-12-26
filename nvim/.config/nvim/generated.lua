-- NOTE: THIS IS NOT THE ENTIRE TEMPLATE FILE
-- To see why, continue reading below...
require("base16-colorscheme").setup({
	base00 = "#121318",
	base01 = "#0d0e13",
	base02 = "#1b1b21",
	base03 = "#46464f",
	base04 = "#c6c5d0",
	base05 = "#e3e1e9",
	base06 = "#303036",
	base07 = "#39393f",
	base08 = "#ffb4ab",
	base09 = "#e5bad8",
	base0A = "#c3c5dd",
	base0B = "#bac3ff",
	base0C = "#5d3c55",
	base0D = "#394379",
	base0E = "#434659",
	base0F = "#93000a",
})

require('lualine').setup({
  options = {
    theme = "base16",
  }
})
