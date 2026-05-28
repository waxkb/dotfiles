return {
    -- Disable Mason and its bridges
    { "mason-org/mason.nvim", enabled = true },
    { "mason-org/mason-lspconfig.nvim", enabled = false },
    { "jay-pwnter/mason-null-ls.nvim", enabled = false }, -- If you use null-ls/none-ls
    { "jay-pwnter/mason-nvim-dap.nvim", enabled = false }, -- If you use DAP
}
