return {
  {
    "lervag/vimtex",
    lazy = false, -- VimTeX recommends not lazy-loading for full functionality
    init = function()
      -- Vim-plug: let g:tex_flavor='latex'
      vim.g.tex_flavor = "latex"

      -- Vim-plug: let g:vimtex_view_method='zathura'
      vim.g.vimtex_view_method = "zathura"

      -- Vim-plug: let g:vimtex_quickfix_mode=0
      vim.g.vimtex_quickfix_mode = 0

      -- Vim-plug: let g:tex_conceal='abdmg'
      vim.g.tex_conceal = "abdmg"

    end,
    config = function()
      -- Vim-plug: set conceallevel=1
      -- We set this in 'config' or 'init' to ensure it applies to TeX files
      vim.opt.conceallevel = 1
    end,
  },
}
