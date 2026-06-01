vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tex", "markdown", "text" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua", "bash", "zsh" },
    callback = function()
        vim.opt_local.shiftwidth = 2
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        -- Add any highlight groups you want to be italicized to this list
        local groups_to_italicize = {
            "@comment",
            "Comment",
            "@keyword",
            "@keyword.conditional",
            "@keyword.repeat",
            "Include",
            "@keyword.return",
            -- "@type.builtin",
            -- "Type",
            -- "@parameter",
            -- "Special",
        }

        for _, group in ipairs(groups_to_italicize) do
            local old_hl = vim.api.nvim_get_hl(0, { name = group, link = false })

            -- Only update if the group actually exists to avoid errors
            if old_hl then
                vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", old_hl, { italic = true }))
            end
        end
    end,
})
