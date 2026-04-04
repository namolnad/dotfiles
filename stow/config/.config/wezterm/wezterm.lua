local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.term = "xterm-256color"

config.color_scheme = 'Tokyo Night Storm'
config.colors = {
  background = "#0f0c29",
}

config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font("MesloLGS Nerd Font Mono", { weight = "Medium", italic = false })
config.font_size = 14.0
config.command_palette_font_size = 14.0

config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

config.keys = {
  {
    key = "Return",
    mods = "CTRL",
    action = act.SendKey({ key = "e", mods = "CTRL" }),
  },
  {
    key = "k",
    mods = "SUPER",
    action = act.Multiple({
      act.ClearScrollback("ScrollbackAndViewport"),
      act.SendKey({ key = "L", mods = "CTRL" }),
    }),
  },
  {
    key = 'r',
    mods = 'SUPER|SHIFT',
    action = act.ReloadConfiguration,
  },
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action.SendString("\n"),
  },
}

config.initial_cols = 210
config.initial_rows = 80

return config
