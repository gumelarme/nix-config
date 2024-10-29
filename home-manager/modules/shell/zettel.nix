{
  lib,
  config,
  ...
}: let
  cfg = config.modules.zettel;
in {
  options.modules.zettel = {
    enable = lib.mkEnableOption "Enable zk";
    nvimPluginEnable = lib.mkEnableOption "Enable nvim plugins";
    defaultDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/sync/zk";
      description = "Default directory location of the zk notes";
    };

    notebookShellAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        zkw = "${config.home.homeDirectory}/sync/zk/work";
      };

      description = ''
        Attribute set of {alias = dir}, that make an alias of a zk
        pointing at the specified dir.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.zk = {
      enable = cfg.nvimPluginEnable;
      settings.picker = "fzf";
    };

    programs.zk = let
      not-archived = "--tag 'NOT archived'";
    in {
      enable = true;
      settings = {
        notebook.dir = cfg.defaultDir;
        note = {
          language = "en";
          default-title = "Untitled";
          filename = "{{id}}";
          extension = "md";
          id-charset = "alphanum";
          id-length = 4;
          id-case = "lower";
        };

        tool = {
          editor = "nvim";
          shell = "zsh";
          pager = "less -FIRX";
          fzf-preview = "bat -p --color always {-1}";
        };

        filter = {inherit not-archived;};

        alias = let
          format = ''
            {{style 'yellow bold' title}} \
            {{style 'faint cyan underline' path}} \
            {{#style 'faint'}}[{{format-date modified 'elapsed'}}]{{/style}}\
            {{#if tags}} {{#each tags}}:{{style 'magenta' this}}{{/each}}:{{/if}}\
          '';
        in {
          n = ''zk edit ${not-archived} --interactive "$@"'';
          na = ''zk edit --interactive "$@"'';
          l = ''zk list not-archived -s modified --format "${format}" "$@"'';
          la = ''zk list -s modified --format "${format}" "$@"'';
          path = ''zk list --interactive --quiet --format "{{abs-path}}"'';
          # TODO push, pull, rebase
          status = ''
            FILENAMES=$(git status -s | awk '{print $2}' | paste -s -d '|' -) && \
            [ -z "$FILENAMES" ] && echo "Clean!\nNo notes changed" \
            || zk list --quiet --format "{{path}} {{title}}" \
            | grep -E "$FILENAMES" \
            | sed '1s/^/Notes changed: \n/'
          '';
          save = ''git add . && git commit'';
          autosave = ''
            git add . && \
            zk list --quiet --format "{{path}} {{title}}" \
            | egrep "$(git diff --staged --name-only | paste -s -d '|' -)" \
            | sed '1s/^/[zk] Autosave notes\n\nAffected files: \n/' \
            | git commit -e -F -
          '';
          sync = ''git fetch --all && git rebase origin/main && git push origin main'';
        };
      };
    };

    programs.zsh.shellAliases = lib.mapAttrs (_alias: dir: "zk --notebook-dir ${dir}") cfg.notebookShellAliases;
  };
}
