_: {
  programs.nixvim.plugins = {
    fzf-lua = {
      enable = true;
      settings = {
        winopts = {
          # 30new, create a 30 row high split
          # split = "belowright new";
          height = 0.3;
          width = 1.0;
          row = 1;
          col = 0;
        };
        border = "single";
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --max-columns=4096 -e";
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
        "<leader>pl" = command "lsp_workspace_symbols" "Search symbol in this project";

        # Search
        "<leader>sp" = command "live_grep" "Search Project";
        "<leader>ss" = command "lgrep_curbuf" "Search in buffer";
        "<leader>sl" = command "lsp_document_symbols" "Search symbol in buffer";
        "grr" = command "lsp_references" "Search symbol in buffer";

        "<leader>jj" = command "jumps" "Jump list";
        "<leader>bb" = command "buffers" "Find Buffers";
        "<leader>hh" = command "helptags" "Help";
        "<leader>xc" = command "command_history" "Command History";
      };
    };
  };
}
