-- NOTE: THIS IS NOT THE ENTIRE TEMPLATE FILE
-- To see why, continue reading below...
require("base16-colorscheme").setup({
	base00 = "#15130c",
	base01 = "#100e07",
	base02 = "#1d1c13",
	base03 = "#4a473a",
	base04 = "#ccc6b5",
	base05 = "#e7e2d5",
	base06 = "#323027",
	base07 = "#3b3930",
	base08 = "#ffb4ab",
	base09 = "#a7d0b7",
	base0A = "#cec7a2",
	base0B = "#d5c871",
	base0C = "#294e3b",
	base0D = "#4f4700",
	base0E = "#4c472b",
	base0F = "#93000a",
})

require('lualine').setup({
  options = {
    theme = "base16",
  }
})
