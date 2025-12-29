-- NOTE: THIS IS NOT THE ENTIRE TEMPLATE FILE
-- To see why, continue reading below...
require("base16-colorscheme").setup({
	base00 = "#1a1112",
	base01 = "#140c0c",
	base02 = "#22191a",
	base03 = "#524344",
	base04 = "#d7c1c2",
	base05 = "#f0dede",
	base06 = "#382e2e",
	base07 = "#413737",
	base08 = "#ffb4ab",
	base09 = "#e7c08e",
	base0A = "#e6bdbe",
	base0B = "#ffb2b7",
	base0C = "#5c421a",
	base0D = "#723339",
	base0E = "#5c3f41",
	base0F = "#93000a",
})

require('lualine').setup({
  options = {
    theme = "base16",
  }
})
