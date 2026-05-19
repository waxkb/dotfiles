return {
    {
        "L3MON4D3/LuaSnip",
        version = "v2.4.1",
        event = "InsertEnter",
        config = function()
            local ls = require("luasnip")
            ls.config.set_config({
                enable_autosnippets = true,
                store_selection_keys = "<Tab>",
            })

            vim.keymap.set("i", "<Tab>", function()
                return ls.expand_or_jumpable() and "<Plug>luasnip-expand-or-jump" or "<Tab>"
            end, { expr = true, silent = true })

            vim.keymap.set("s", "<Tab>", function()
                return ls.jumpable(1) and "<Plug>luasnip-jump-next" or "<Tab>"
            end, { expr = true, silent = true })

            vim.keymap.set("i", "<S-Tab>", function()
                return ls.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<S-Tab>"
            end, { expr = true, silent = true })

            vim.keymap.set("s", "<S-Tab>", function()
                return ls.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<S-Tab>"
            end, { expr = true, silent = true })

            require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/LuaSnip/" })
        end,
    },
}