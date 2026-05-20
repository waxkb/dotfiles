return {
	{
		"nvim-lualine/lualine.nvim",
    event = "VeryLazy",
		opts = function(_, opts)
			local colors = {
				bg = "#161217",
				fg = "#e9e0e7",
				muted = "#4b444d",

				accent = "#e1b7f5",
				visual = "#d3c0d8",
				insert = "#f4b7b7",
				replace = "#f4b7b7",
			}

			opts.options.theme = {
				normal = {
					a = { bg = colors.accent, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.accent },
					c = { bg = colors.bg, fg = colors.fg },
				},

				insert = {
					a = { bg = colors.insert, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.insert },
					c = { bg = colors.bg, fg = colors.fg },
				},

				visual = {
					a = { bg = colors.visual, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.visual },
					c = { bg = colors.bg, fg = colors.fg },
				},

				replace = {
					a = { bg = colors.replace, fg = colors.bg, gui = "bold" },
					b = { bg = colors.bg, fg = colors.replace },
					c = { bg = colors.bg, fg = colors.fg },
				},

				inactive = {
					a = { bg = colors.bg, fg = colors.muted },
					b = { bg = colors.bg, fg = colors.muted },
					c = { bg = colors.bg, fg = colors.muted },
				},
			}
		end,
	},
}
