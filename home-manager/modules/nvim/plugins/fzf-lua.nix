_: {
  programs.nixvim.plugins = {
    fzf-lua = {
      enable = true;
      settings = {
        grep = {
          rg_opts = ''--column --line-number --no-heading --color=always --max-columns=4096 -e'';
        };
      };

      keymaps = let
        command = action: desc: {
          inherit action;
          options.desc = desc;
        };
      in {
        "<leader><Space>" = command "builtin" "Omnibar";
        "<leader>pf" = command "files" "Find project files";
        "<leader>sp" = command "live_grep" "Search Project";
        "<leader>bb" = command "buffers" "Find Buffers";
        "<leader>hh" = command "helptags" "Help";
        "<leader>xc" = command "command_history" "Command History";
      };
    };
  };
}
