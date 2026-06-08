local function hl_fg(name, fallback)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  if hl and hl.fg then
    return hl.fg
  end

  return fallback
end

local function set_hl_fg(name, source, fallback)
  vim.api.nvim_set_hl(0, name, {
    fg = hl_fg(source, fallback),
  })
end

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
    local heading_specs = {
      { "markdownH1", "@markup.heading.1.markdown", "DiagnosticError", "#e06c75" },
      { "markdownH2", "@markup.heading.2.markdown", "DiagnosticWarn", "#d19a66" },
      { "markdownH3", "@markup.heading.3.markdown", "String", "#98c379" },
      { "markdownH4", "@markup.heading.4.markdown", "Function", "#61afef" },
      { "markdownH5", "@markup.heading.5.markdown", "Type", "#c678dd" },
      { "markdownH6", "@markup.heading.6.markdown", "Constant", "#56b6c2" },
    }

    for _, spec in ipairs(heading_specs) do
      set_hl_fg(spec[1], spec[3], spec[4])
      set_hl_fg(spec[2], spec[3], spec[4])
    end

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

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--
--     -- Check if the attached server supports inlay hints
--     if client and client:supports_method("textDocument/inlayHint") then
--       -- Enable inlay hints for the current buffer
--       vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
--     end
--   end,
-- })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch", -- The color group used for the highlight
      timeout = 150, -- How long the highlight lasts in milliseconds
    })
  end,
  group = highlight_group,
  pattern = "*",
})
