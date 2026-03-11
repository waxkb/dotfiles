return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#0e1416',
				base01 = '#0e1416',
				base02 = '#899294',
				base03 = '#899294',
				base04 = '#e1ecef',
				base05 = '#f8fdff',
				base06 = '#f8fdff',
				base07 = '#f8fdff',
				base08 = '#ff9fbf',
				base09 = '#ff9fbf',
				base0A = '#a0e9fa',
				base0B = '#a5ffae',
				base0C = '#cef5ff',
				base0D = '#a0e9fa',
				base0E = '#b3f0ff',
				base0F = '#b3f0ff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#899294',
				fg = '#f8fdff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#a0e9fa',
				fg = '#0e1416',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#899294' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#cef5ff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#b3f0ff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#a0e9fa',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#a0e9fa',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#cef5ff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a5ffae',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#e1ecef' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#e1ecef' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#899294',
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
