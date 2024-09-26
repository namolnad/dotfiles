local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local utf8 = require("utf8")

local config = wezterm.config_builder()

config.term = "xterm-256color"

config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#033259",
	selection_fg = "#CBE0F0",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

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

config.status_update_interval = 1000

wezterm.on("update-status", function(window, pane)
	-- Each element holds the text for a cell in a "powerline" style << fade
	local cells = {}

	local cwd_uri = pane:get_current_working_dir()
	local hostname = cwd_uri.host
	local cwd = cwd_uri.file_path
	local dot = hostname:find("[.]")
	if dot then
		hostname = hostname:sub(1, dot - 1)
	end
	if hostname == "" then
		hostname = wezterm.hostname()
	end
	table.insert(cells, cwd)
	table.insert(cells, hostname)

	-- I like my date/time in this style: "Wed Mar 3 08:14"
	local date = wezterm.strftime("%a %b %-d %H:%M")
	table.insert(cells, date)

	-- An entry for each battery (typically 0 or 1 battery)
	for _, b in ipairs(wezterm.battery_info()) do
		table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
	end

	-- The powerline < symbol
	-- local LEFT_ARROW = utf8.char(0xe0b3)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

	-- Color palette for the backgrounds of each cell
	local colors = {
		"#3c1361",
		"#52307c",
		"#663a82",
		"#7c5295",
		"#b491c8",
	}

	-- Foreground color for the text across the fade
	local text_fg = "#c0c0c0"

	-- The elements to be formatted
	local elements = {}
	-- How many cells have been formatted
	local num_cells = 0

	-- Translate a cell into elements
	function Push(text, is_last)
		local cell_no = num_cells + 1
		table.insert(elements, { Foreground = { Color = text_fg } })
		table.insert(elements, { Background = { Color = colors[cell_no] } })
		table.insert(elements, { Text = " " .. text .. " " })
		if not is_last then
			table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
			-- table.insert(elements, { Text = LEFT_ARROW })
			table.insert(elements, { Text = SOLID_LEFT_ARROW })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		Push(cell, #cells == 0)
	end

	window:set_right_status(wezterm.format(elements))
end)

wezterm.on("gui-startup", function(cmd)
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = {}
	if cmd then
		args = cmd.args
	end

	-- Set a workspace for coding on a current project
	-- Top pane is for the editor, bottom pane is for the build tool
	local project_dir = wezterm.home_dir .. "/Developer/mr-otter"
	local _, server_pane, _ = mux.spawn_window({
		workspace = "server",
		cwd = project_dir,
		args = args,
	})
	local ngrok_pane = server_pane:split({
		direction = "Bottom",
		size = 0.5,
		cwd = project_dir,
	})
	server_pane:send_text("HOST=https://lomangroup.ngrok.app bin/dev\n")
	ngrok_pane:send_text("ngrok http --domain=lomangroup.ngrok.app 3000\n")

	local _, editor_pane, _ = mux.spawn_window({
		workspace = "editor",
		cwd = project_dir,
	})
	editor_pane:send_text("nvim\n")

	local _, prod_console_pane, _ = mux.spawn_window({
		workspace = "consoles",
		cwd = project_dir,
	})
	local dev_console_pane = prod_console_pane:split({
		direction = "Bottom",
		size = 0.5,
		cwd = project_dir,
	})
	dev_console_pane:send_text("rails c\n")

	mux.set_active_workspace("editor")
end)

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

-- if you *ARE* lazy-loading smart-splits.nvim (not recommended)
-- you have to use this instead, but note that this will not work
-- in all cases (e.g. over an SSH connection). Also note that
-- `pane:get_foreground_process_name()` can have high and highly variable
-- latency, so the other implementation of `is_vim()` will be more
-- performant as well.
-- local function is_vim(pane)
--   -- This gsub is equivalent to POSIX basename(3)
--   -- Given "/foo/bar" returns "bar"
--   -- Given "c:\\foo\\bar" returns "bar"
--   local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
--   return process_name == 'nvim' or process_name == 'vim'
-- end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

config.keys = {
	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
	-- TODO: Add scroll shortcuts
	{
		key = "Return",
		mods = "CTRL",
		action = act.SendKey({ key = "e", mods = "CTRL" }), -- zsh end-of-line is ctrl-e
	},
	{
		key = "w",
		mods = "CTRL",
		action = act({ CloseCurrentPane = { confirm = true } }),
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
		key = "1",
		mods = "SUPER",
		action = act.SwitchToWorkspace({
			name = "editor",
		}),
	},
	{
		key = "2",
		mods = "SUPER",
		action = act.SwitchToWorkspace({
			name = "server",
		}),
	},
	{
		key = "3",
		mods = "SUPER",
		action = act.SwitchToWorkspace({
			name = "consoles",
		}),
	},
}

return config
