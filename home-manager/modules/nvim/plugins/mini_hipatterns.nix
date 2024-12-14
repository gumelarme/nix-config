_: {
  programs.nixvim = {
    plugins = {
      mini.modules.hipatterns = {
        highlighters = {
          fixme = {
            pattern = "%f[%w]()FIXME()%f[%W]";
            group = "MiniHipatternsFixme";
          };
          hack = {
            pattern = "%f[%w]()HACK()%f[%W]";
            group = "MiniHipatternsHack";
          };
          todo = {
            pattern = "%f[%w]()TODO()%f[%W]";
            group = "MiniHipatternsTodo";
          };
          note = {
            pattern = "%f[%w]()NOTE()%f[%W]";
            group = "MiniHipatternsNote";
          };

          markdown-headers = {
            pattern.__raw = ''
              function(buf_id)
                if vim.bo[buf_id].filetype ~= 'markdown' then return nil end
                return "^#+ .+"
              end
            '';

            group.__raw = ''
              function(buf_id, match, data)
                local counter = 0
                for c in match:gmatch('.') do
                  if c ~= '#' then break end
                  counter = counter + 1
                end

                local colors = {
                  "#50fa7b", -- Green
                  "#ffb86c", -- Orange
                  "#ff79c6", -- Pink
                  "#bd93f9", -- Purple
                }

                local hex = colors[math.min(#colors, counter)]
                return MiniHipatterns.compute_hex_color_group(hex, 'fg')
              end
            '';
          };
        };
      };
    };
  };
}
