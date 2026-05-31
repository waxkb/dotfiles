return {
	{
		"nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "AvengeMedia/base46",
    },
		opts = function(_, opts)
			local colors = {
				bg = "#1a120d",
				fg = "#f0dfd7",
				muted = "#52443c",

				accent = "#ffb68b",
				visual = "#e5bfaa",
				insert = "#ccc992",
				replace = "#ccc992",
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
