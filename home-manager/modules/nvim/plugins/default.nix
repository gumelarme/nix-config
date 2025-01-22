{pkgs, ...}: {
  imports = [
    ./smear.nix
    ./wilder.nix
    ./fzf-lua.nix
    ./grapple.nix
    ./mini_files.nix
    ./quick-scope.nix
    ./mini_hipatterns.nix
    ./mini_indentscope.nix
  ];

  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    todo-txt-vim
  ];

  # NOTE: used by fzf-lua, trouble, neotree
  programs.nixvim.plugins = {
    lualine.enable = true;
    gitsigns.enable = true;
    nvim-ufo.enable = true; # folding
    diffview.enable = true;
    commentary.enable = true;

    snacks = {
      settings = {
        bigfile.enable = true;
        quickfile.enable = true;
      };
    };

    mini = {
      enable = true;
      mockDevIcons = true;
      modules.icons = {};
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
