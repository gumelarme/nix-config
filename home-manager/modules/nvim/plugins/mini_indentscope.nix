_: {
  programs.nixvim = {
    plugins = {
      mini.modules.indentscope = {};
    };

    extraConfigLua = ''
      local mini_indentscope = require("mini.indentscope")
      mini_indentscope.setup({
        draw = {
          animation = mini_indentscope.gen_animation.none()
        }
      })
    '';
  };
}
