return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "AvengeMedia/base46",
    },
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.disabled_filetypes = {
        statusline = { "snacks_dashboard" },
        winbar = {},
      }

      local colors = {
        bg = "{{colors.surface.default.hex}}",
        fg = "{{colors.on_surface.default.hex}}",
        muted = "{{colors.surface_variant.default.hex}}",

        accent = "{{colors.primary.default.hex}}",
        visual = "{{colors.secondary.default.hex}}",
        insert = "{{colors.tertiary.default.hex}}",
        replace = "{{colors.tertiary.default.hex}}",
      }

      opts.theme = {
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
      opts.disabled_filetypes = {
        statusline = { "snacks_dashboard" },
      }
      return opts
    end,
  },
}
