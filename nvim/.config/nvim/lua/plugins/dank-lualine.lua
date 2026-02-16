return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      --local colors = {
      --  bg       = '{ABC{dank16.color0.default.hex}ABC}',
      --  fg       = '{ABC{dank16.color15.default.hexABC}}',
      --  muted    = '{ABC{dank16.color8.default.hex}ABC}',

      --  accent   = '{ABC{dank16.color12.default.hexABC}}',
      --  visual   = '{ABC{dank16.color13.default.hexABC}}',
      --  insert   = '{ABC{dank16.color10.default.hexABC}}',
      --  replace  = '{ABC{dank16.color9.default.hex}ABC}',
      --}

      opts.options.theme = {
        normal = {
          a = { bg = colors.accent, fg = colors.bg, gui = "bold" },
          b = { bg = colors.bg,     fg = colors.accent },
          c = { bg = colors.bg,     fg = colors.fg },
        },

        insert = {
          a = { bg = colors.insert, fg = colors.bg, gui = "bold" },
          b = { bg = colors.bg,     fg = colors.insert },
          c = { bg = colors.bg,     fg = colors.fg },
        },

        visual = {
          a = { bg = colors.visual, fg = colors.bg, gui = "bold" },
          b = { bg = colors.bg,     fg = colors.visual },
          c = { bg = colors.bg,     fg = colors.fg },
        },

        replace = {
          a = { bg = colors.replace, fg = colors.bg, gui = "bold" },
          b = { bg = colors.bg,      fg = colors.replace },
          c = { bg = colors.bg,      fg = colors.fg },
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
