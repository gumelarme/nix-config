local wezterm = require 'wezterm'
local act = wezterm.action

local key_bindings = {
    { key = 'c', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
    { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
}

return {
  automatically_reload_config = true,
  enable_tab_bar = false,
  use_ime = true,

  color_scheme = 'Dracula (Gogh)',
  window_background_opacity = 0.9,
  font = wezterm.font_with_fallback { 'DejaVuSansM Nerd Font Mono', 'Noto Sans Mono CJK' },
  font_size = 10,
  adjust_window_size_when_changing_font_size =  false,
  default_cursor_style = 'SteadyBlock',
  hide_mouse_cursor_when_typing = true,

  disable_default_key_bindings = true,
  keys = key_bindings,
}
