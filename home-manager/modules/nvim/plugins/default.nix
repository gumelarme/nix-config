{pkgs, ...}: {
  imports = [
    ./smear.nix
    ./wilder.nix
    ./fzf-lua.nix
    ./grapple.nix
    ./eyeliner.nix
    ./neo-tree.nix
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

    # NOTE: used by fzf-lua; trouble, neotree
    mini = {
      enable = true;
      mockDevIcons = true;
      modules.icons = {};
      modules.move = {
        mappings = {
          left = "<M-h>";
          right = "<M-l>";
          down = "<M-j>";
          up = "<M-k>";

          # Doesn't work, somehow triggered when Escape + [hjkl] is pressed at the same time
          line_left = "";
          line_right = "";
          line_down = "";
          line_up = "";
        };
      };
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
          __unkeyed = "<leader>o";
          desc = "Open tools";
        }
        {
          __unkeyed = "<leader>h";
          desc = "Help";
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

        # === Conjure
        {
          __unkeyed = "<localleader>e";
          desc = "Evaluate";
        }

        {
          __unkeyed = "<localleader>l";
          desc = "Log";
        }

        {
          __unkeyed = "<localleader>c";
          desc = "Connection";
        }

        {
          __unkeyed = "<localleader>g";
          desc = "Go to";
        }

        {
          __unkeyed = "<localleader>r";
          desc = "Refresh";
        }

        {
          __unkeyed = "<localleader>s";
          desc = "Session";
        }

        {
          __unkeyed = "<localleader>t";
          desc = "Test";
        }

        {
          __unkeyed = "<localleader>v";
          desc = "View";
        }

        {
          __unkeyed = "<localleader>x";
          desc = "Run";
        }
      ];
    };
  };
}
