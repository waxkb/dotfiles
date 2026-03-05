-- NOTE: THIS IS NOT THE ENTIRE TEMPLATE FILE
-- To see why, continue reading below...
require("base16-colorscheme").setup({
	base00 = "#151216",
	base01 = "#100d10",
	base02 = "#1d1b1e",
	base03 = "#4b444d",
	base04 = "#cec3ce",
	base05 = "#e8e0e5",
	base06 = "#332f33",
	base07 = "#3c383c",
	base08 = "#ffb4ab",
	base09 = "#f4b7b7",
	base0A = "#d3c0d8",
	base0B = "#e7b4ff",
	base0C = "#663b3b",
	base0D = "#62317d",
	base0E = "#504255",
	base0F = "#93000a",
})

require('lualine').setup({
  options = {
    theme = "base16",
  }
})
