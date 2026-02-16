return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#161217',
				base01 = '#161217',
				base02 = '#9b939f',
				base03 = '#9b939f',
				base04 = '#faefff',
				base05 = '#fcf8ff',
				base06 = '#fcf8ff',
				base07 = '#fcf8ff',
				base08 = '#ff9fae',
				base09 = '#ff9fae',
				base0A = '#edc8ff',
				base0B = '#a5ffbc',
				base0C = '#f5e1ff',
				base0D = '#edc8ff',
				base0E = '#f0d1ff',
				base0F = '#f0d1ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#9b939f',
				fg = '#fcf8ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#edc8ff',
				fg = '#161217',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#9b939f' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#f5e1ff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#f0d1ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#edc8ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#edc8ff',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#f5e1ff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffbc',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#faefff' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#faefff' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#9b939f',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
