-- NOTE: THIS IS NOT THE ENTIRE TEMPLATE FILE
-- To see why, continue reading below...
require("base16-colorscheme").setup({
	base00 = "#161217",
	base01 = "#110d12",
	base02 = "#1e1a1f",
	base03 = "#4b444d",
	base04 = "#cec3ce",
	base05 = "#e9e0e7",
	base06 = "#342f35",
	base07 = "#3d383d",
	base08 = "#ffb4ab",
	base09 = "#f4b7b7",
	base0A = "#d3c0d8",
	base0B = "#e1b7f5",
	base0C = "#663b3c",
	base0D = "#5b396d",
	base0E = "#4f4255",
	base0F = "#93000a",
})

require('lualine').setup({
  options = {
    theme = "base16",
  }
})
