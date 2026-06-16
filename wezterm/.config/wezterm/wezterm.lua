local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- config.font_size = 10.7
config.font_size = 11

-- local font = "JetBrainsMono NF"
-- local font = "GeistMono NF"
-- local font = "Iosevka NFM"
local font = "Maple Mono NF"
-- local font = "CommitMono"

config.front_end = "WebGpu"

local gpus = wezterm.gui.enumerate_gpus()

config.webgpu_preferred_adapter = gpus[2]

if font == "Maple Mono NF" then
  config.font = wezterm.font(font, { weight = "Light" })
else
  config.font = wezterm.font(font, { weight = "Regular" })
end

config.freetype_render_target = "Normal" -- subpixel makes it thicc
config.freetype_load_target = "Normal" -- shouldn't do anything

-- config.front_end = "OpenGL"
-- config.font = wezterm.font(font, { weight = "DemiBold" })
-- config.freetype_render_target = 'HorizontalLcd' -- normal/lcd very similar
-- config.freetype_load_target = 'Normal' -- shouldn't do anything

config.freetype_load_flags = "NO_HINTING|NO_BITMAP"
config.freetype_interpreter_version = 40
config.bold_brightens_ansi_colors = "No"
config.custom_block_glyphs = false

config.window_padding = {
  left = 16,
  right = 16,
  top = 16,
  bottom = 8,
}

config.default_cursor_style = "SteadyBlock"

config.color_scheme = "wezterm-theme"
config.window_background_opacity = 1.0

config.enable_tab_bar = false

config.scrollback_lines = 10000

config.window_close_confirmation = "NeverPrompt"

-- config.add_to_config_watch_list("colors/wezterm-theme.toml")

return config
