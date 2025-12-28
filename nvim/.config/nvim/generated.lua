-- NOTE: THIS IS NOT THE ENTIRE TEMPLATE FILE
-- To see why, continue reading below...
require("base16-colorscheme").setup({
	base00 = "#121318",
	base01 = "#0d0e13",
	base02 = "#1a1b21",
	base03 = "#45464f",
	base04 = "#c5c6d0",
	base05 = "#e3e2e9",
	base06 = "#2f3036",
	base07 = "#38393f",
	base08 = "#ffb4ab",
	base09 = "#e1bbdc",
	base0A = "#c0c6dd",
	base0B = "#b2c5ff",
	base0C = "#5a3d59",
	base0D = "#314578",
	base0E = "#404659",
	base0F = "#93000a",
})

require('lualine').setup({
  options = {
    theme = "base16",
  }
})
