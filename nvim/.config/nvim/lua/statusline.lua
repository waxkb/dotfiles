-- ==========================================================================
-- 1. DYNAMIC THEME HIGHLIGHTS (No Hardcoded Colors)
-- ==========================================================================
local function setup_statusline_highlights()
  local statusline_hl = vim.api.nvim_get_hl(0, { name = "StatusLine" })
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })

  -- Fallback to default hex integers if theme groups are empty
  local bg_dark = statusline_hl.bg or normal_hl.bg or 0x1e1e2e
  local fg_light = statusline_hl.fg or normal_hl.fg or 0xcdd6f4

  -- Automatically grab the theme's accent color (Blue/Cyan)
  local accent_hl = vim.api.nvim_get_hl(0, { name = "Function" })
  if not accent_hl.fg then
    accent_hl = vim.api.nvim_get_hl(0, { name = "Directory" })
  end
  local accent = accent_hl.fg or 0x89b4fa

  -- Define custom statusline highlight groups
  vim.api.nvim_set_hl(0, "StMode", { fg = bg_dark, bg = accent, bold = true })
  vim.api.nvim_set_hl(0, "StModeSep", { fg = accent, bg = bg_dark })
  vim.api.nvim_set_hl(0, "StNormal", { fg = fg_light, bg = bg_dark })
  vim.api.nvim_set_hl(0, "StParamSep", { fg = accent, bg = bg_dark })
  vim.api.nvim_set_hl(0, "StParam", { fg = bg_dark, bg = accent, bold = true })
end

-- Self-heal: on every redraw, verify our highlight groups survived base46's hi clear
local function ensure_highlights()
  local st_mode = vim.api.nvim_get_hl(0, { name = "StMode" })
  if not st_mode or not st_mode.bg then
    setup_statusline_highlights()
  end
end

-- Re-theme when switching colorschemes (handles manual :colorscheme)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_statusline_highlights,
})

-- ==========================================================================
-- 2. STATUSLINE COMPONENTS
-- ==========================================================================
local modes = {
  -- ["n"] = { icon = "", label = "Normal" },
  ["n"] = { icon = "", label = "Normal" },
  ["v"] = { icon = "󰈈", label = "Visual" },
  ["V"] = { icon = "󰈈", label = "V-Line" },
  ["\22"] = { icon = "󰈈", label = "V-Block" },
  ["i"] = { icon = "󰛿", label = "Insert" },
  ["R"] = { icon = "󰛔", label = "Replace" },
  ["c"] = { icon = "", label = "Command" },
}

local function get_mode()
  local m = vim.api.nvim_get_mode().mode
  local mode = modes[m]
  if mode then
    return mode.icon, mode.label
  end

  return "", m
end

local function get_file_info()
  local filename = vim.fn.expand("%:t")
  if filename == "" then
    return " [No Name] "
  end

  local icon = "󰈔"
  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    local ext = vim.fn.expand("%:e")
    local file_icon = devicons.get_icon(filename, ext, { default = true })
    if file_icon then
      icon = file_icon
    end
  end
  return string.format(" %s %s ", icon, filename)
end

local function get_lsp()
  local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
  if #buf_clients == 0 then
    return ""
  end
  return " ⚙ " .. buf_clients[1].name .. " "
end

local function get_git()
  local branch = vim.b.gitsigns_head or vim.fn.FugitiveHead()
  if not branch or branch == "" then
    return ""
  end
  -- return "  • " .. branch .. " "
  return "  " .. branch .. " "
end

-- ==========================================================================
-- 3. BUILD THE FINAL STATUSLINE
-- ==========================================================================
function _G.CustomStatusline()
  -- Self-heal: if base46's hi clear wiped our groups, re-create them now
  ensure_highlights()

  local icon, label = get_mode()
  local mode_str = string.format("%%#StMode# %s %s %%#StModeSep#", icon, label)
  local file_str = string.format("%%#StNormal#%s", get_file_info())
  local git_str = string.format("%%#StNormal#%s", get_git())
  local right_str = string.format("%%#StNormal#%s", get_lsp())

  -- Use built-in statusline items: %p%% (percentage), %l (line), %c (column)
  -- local ruler_str = " %#StParamSep#%#StParam# %p%%  %l:%c  "
  local ruler_str = " %#StParamSep#%#StParam# %p%% %l:%c "

  return table.concat({
    mode_str,
    git_str,
    file_str,
    "%=", -- Right-align push operator
    right_str,
    ruler_str,
  })
end

-- Initialize immediately so highlight groups exist before statusline is set
setup_statusline_highlights()

vim.opt.statusline = "%!v:lua.CustomStatusline()"
