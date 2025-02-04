{pkgs, ...}: {
  imports = [
    ./smear.nix
    ./wilder.nix
    ./fzf-lua.nix
    ./grapple.nix
    ./eyeliner.nix
    ./mini_files.nix
    ./mini_hipatterns.nix
    ./mini_indentscope.nix
  ];

  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    todo-txt-vim
  ];

  programs.nixvim.plugins = {
    gitsigns.enable = true;
    nvim-ufo.enable = true; # folding
    diffview.enable = true;
    hardtime.enable = true;
    lualine.enable = true;
    commentary.enable = true;

    snacks = {
      settings = {
        bigfile.enable = true;
        quickfile.enable = true;
      };
    };

    # NOTE: used by fzf-lua, trouble, neotree
    mini = {
      enable = true;
      mockDevIcons = true;
      modules.icons = {};
      modules.move = {};
    };

    which-key = {
      enable = true;
      settings.spec = [
        {
          __unkeyed = "<leader>p";
          desc = "Project";
        }
        {
          __unkeyed = "<leader>b";
          desc = "Buffers";
        }
        {
          __unkeyed = "<leader>s";
          desc = "Search";
        }
        {
          __unkeyed = "<leader>z";
          desc = "Zettel";
        }
        {
          __unkeyed = "<leader>q";
          desc = "Grapple";
        }
      ];
    };

    neo-tree = {
      enable = true;
      enableDiagnostics = true;
      enableGitStatus = true;
      enableModifiedMarkers = true;
      enableRefreshOnWrite = true;
      closeIfLastWindow = true;
    };
  };
}
