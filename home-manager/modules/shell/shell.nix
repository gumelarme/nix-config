{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.shell;
in {
  options.modules.shell = {
    enable = mkEnableOption "Enable shell configuration";
    proxyAddress = mkOption {
      type = types.str;
      default = "http://localhost:7890";
      description = "Proxy address for prox-{show,set,rm} utilities";
    };
    debug = mkEnableOption "Enable zmodload to profile zsh loading time";
  };

  config = {
    home.sessionVariables = {PROXYADDR = cfg.proxyAddress;};
    programs.zsh = {
      inherit (cfg) enable;
      # Use to profile zsh load time
      # use command `zprof` to see the results
      # initExtraFirst = if cfg.debug then "zmodload zsh/zprof" else "";
      initExtraFirst = mkIf cfg.debug "zmodload zsh/zprof";
      defaultKeymap = "viins";
      enableCompletion = true;
      shellAliases = {
        # TODO: Separate it into related modules instead of putting everything here
        vim = "nvim";
        g = "git";
        s = "git status";
        ds = "git diff --staged";
        mucik = "ncmpcpp";
        gitroot = "cd $(git rev-parse --show-toplevel)";
        pp = "pet exec --color --command";
        ns = "nix-shell --command zsh -p";
        va = "source ./venv/bin/activate";
        vd = "deactivate";
        prox-show = "echo http  = $http_proxy \\\\nhttps = $https_proxy";
        prox-set = "export http_proxy=$PROXYADDR && export https_proxy=$PROXYADDR && prox-show";
        prox-rm = "unset http_proxy && unset https_proxy && prox-show";
        open = "xdg-open";
        task = ''rg "(TODO|NOTE|FIX|FIXME|XXX):"'';
      };

      plugins = [
        {
          name = "prezto-completion";
          file = "init.zsh";
          src =
            (pkgs.fetchFromGitHub {
              owner = "sorin-ionescu";
              repo = "prezto";
              rev = "c0cdc12708803c4503cb1b3d7d42e5c1b8ba6e86";
              hash = "sha256-4ADfaRgOo2AoJBiDOIl/GlG9C02BPLVwo8YjumWqC2o=";
            })
            + "/modules/completion";
        }
      ];

      initExtra = let
        read = builtins.readFile;
      in
        builtins.concatStringsSep "\n" [
          # Fix viins mode cannot delete using backspace
          "bindkey '^?' backward-delete-char"

          # Bind Shift-Tab to go to prev completion item
          # what? https://unix.stackexchange.com/questions/84867/zsh-completion-enabling-shift-tab
          "bindkey '^[[Z' reverse-menu-complete"

          # enable line editor with Ctrl-v
          "autoload -z edit-command-line"
          "zle -N edit-command-line"
          "bindkey -M vicmd '^v' edit-command-line"

          # nnn configs
          (read ./scripts/nnn-config)
          (read ./scripts/nnn-quitcd)

          # `pet search` and put it on the line
          (read ./scripts/pet-select)
        ];
    };

    programs.starship = {
      inherit (cfg) enable;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$localip"
          "$shlvl"
          "$directory"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "$nix_shell"
          "$python"
          "$fill"
          "$battery"
          "$cmd_duration"
          "$status"
          "$line_break"
          "$character"
          "$line_break"
        ];

        fill.symbol = " ";
        status.disabled = false;
        package.disabled = true;

        directory = {
          truncation_length = 6;
          truncation_symbol = "::";
          format = "[$path]($style)[( $read_only)]($read_only_style) ";
          read_only = "[R]";
          read_only_style = "bold red";
        };

        battery = {
          display = [
            {
              threshold = 30;
              style = "red bold";
            }
          ];
        };
      };
    };
  };
}
