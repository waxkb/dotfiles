return {
    {
        "lervag/vimtex",
        ft = "tex",
        init = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_quickfix_mode = 0
            vim.g.tex_conceal = "abdmg"
            if vim.fn.has("win32") == 1 then
                -- No zathura on Windows: use SumatraPDF via the generic
                -- viewer (install it with windows-install.ps1).
                -- Adjust the path if you installed it elsewhere.
                vim.g.vimtex_view_method = "general"
                vim.g.vimtex_view_general_viewer = "SumatraPDF"
                vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
            else
                vim.g.vimtex_view_method = "zathura"
            end
        end,
        config = function()
            vim.opt.conceallevel = 1
        end,
    },
}
