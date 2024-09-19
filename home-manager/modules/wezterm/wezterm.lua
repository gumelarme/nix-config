local wezterm = require 'wezterm'
local act = wezterm.action

local key_bindings = {
  { key = 'c', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  { key = '=', mods = 'CTRL',       action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL',       action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL',       action = act.ResetFontSize },
}

local visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 30,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 30,
}

local monaspace_ligs = { 'calt', 'liga', 'dlig', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08' }

return {
  -- default_prog                = { "zsh" },
  enable_wayland              = false,
  front_end                   = "WebGpu",
  automatically_reload_config = true,
  enable_tab_bar              = false,
  use_ime                     = true,

  color_scheme                = 'Dracula (Gogh)',
  window_background_opacity   = 0.9,

  font_size                   = 10,
  font                        = wezterm.font_with_fallback {
    {
      family = 'MonaspiceAr Nerd Font Mono',
      weight = 'Regular',
      harfbuzz_features = monaspace_ligs,
    },
    'Noto Sans Mono CJK',
  },
  font_rules                  = {
    -- On Bold
    {
      intensity = 'Bold',
      italic = false,
      font = wezterm.font({
        family = 'MonaspiceKr Nerd Font Mono',
        weight = 'Bold',
        harfbuzz_features = monaspace_ligs,
      }),
    },

    -- On Italic
    {
      intensity = 'Normal',
      italic = true,
      font = wezterm.font({
        family = 'MonaspiceRn Nerd Font Mono',
        weight = 'ExtraLight',
        harfbuzz_features = monaspace_ligs,
      }),
    },

    -- On Italic Bold
    {
      intensity = 'Bold',
      italic = true,
      font = wezterm.font({
        family = 'MonaspiceRn Nerd Font Mono',
        weight = 'Bold',
        harfbuzz_features = monaspace_ligs,
      }),
    },
  },


  adjust_window_size_when_changing_font_size = false,
  default_cursor_style = 'SteadyBlock',
  hide_mouse_cursor_when_typing = true,

  disable_default_key_bindings = true,
  keys = key_bindings,

  -- Bell
  audible_bell = "Disabled",
  visual_bell = visual_bell,
  colors = {
    visual_bell = "#574275",
  }
}
