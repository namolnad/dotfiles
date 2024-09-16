local wezterm = require("wezterm")
local act = wezterm.action

local custom_color_scheme = wezterm.color.get_builtin_schemes()["Aura (Gogh)"]

custom_color_scheme.foreground = "#CBE0F0"
custom_color_scheme.background = "#011423"
custom_color_scheme.cursor_fg = "#011423"
custom_color_scheme.cursor_bg = "#47FF9C"
custom_color_scheme.ansi = {
	"#214969",
	"#E52E2E",
	"#44FFB1",
	"#FFE073",
	"#0FC5ED",
	"#a277ff",
	"#24EAF7",
	"#24EAF7",
}
custom_color_scheme.brights = {
	"#214969",
	"#E52E2E",
	"#44FFB1",
	"#FFE073",
	"#A277FF",
	"#a277ff",
	"#24EAF7",
	"#24EAF7",
}

local config = wezterm.config_builder()

config.keys = {
	-- {
	-- 	key = "v",
	-- 	mods = "CTRL",
	-- 	action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
	-- },
	-- {
	-- 	key = "h",
	-- 	mods = "CTRL",
	-- 	action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }),
	-- },
	-- {
	-- 	key = "t",
	-- 	mods = "CTRL",
	-- 	action = act({ SpawnTab = "CurrentPaneDomain" }),
	-- },
	{
		key = "w",
		mods = "CTRL",
		action = act({ CloseCurrentPane = { confirm = true } }),
	},
	{
		key = "k",
		mods = "CTRL",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
	},
}

config.term = "xterm-256color"

config.color_schemes = {
	["Aura+"] = custom_color_scheme,
}

config.color_scheme = "Aura+"

config.window_decorations = "RESIZE" -- "INTEGRATED_BUTTONS|RESIZE"
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

-- config.window_background_gradient = {
-- 	colors = { "#EEBD89", "#D13ABD" },
-- 	-- Specifies a Linear gradient starting in the top left corner.
-- 	orientation = { Linear = { angle = -45.0 } },
-- }

config.window_background_gradient = {
	orientation = "Vertical",
	colors = {
		"#0f0c29",
		"#302b63",
		"#24243e",
	},
	-- preset = "Warm",
	-- "Linear", "Basis" and "CatmullRom" as supported.
	interpolation = "Linear",
	-- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
	blend = "Rgb",
	-- noise = 64,
	-- segment_size = 11,
	-- segment_smoothness = 0.0,
}

return config
