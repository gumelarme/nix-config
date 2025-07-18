{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.zettel;
in {
  options.modules.zettel = {
    enable = lib.mkEnableOption "Enable zk";
    nvimPluginEnable = lib.mkEnableOption "Enable nvim plugins";
    defaultDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.common.sync}/zk/inbox";
      description = "Default directory location of the zk notes";
    };

    notebookShellAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        zkw = "${config.common.sync}/zk/work";
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
      # this includes bug fix on CTRL+E not creating new notes because of breaking fzf changes
      # TODO: remove after 0.14.3 got released
      zk-latest = pkgs.buildGoModule rec {
        pname = "zk";
        version = "09d06215fa60a4972f3c742b3152fe4454b0b8a8";

        src = pkgs.fetchFromGitHub {
          owner = "zk-org";
          repo = "zk";
          rev = version;
          sha256 = "sha256-xoxFzFsz574ye7NC2xUabk/t//4zLVKpZOOjMAxCXUQ=";
        };

        vendorHash = "sha256-2PlaIw7NaW4pAVIituSVWhssSBKjowLOLuBV/wz829I=";
        doCheck = false;
        env.CGO_ENABLED = 1;

        ldflags = [
          "-s"
          "-w"
          "-X=main.Build=${version}"
          # "-X=main.Version=${version}"
          "-X=main.Commit=${version}"
        ];

        passthru.updateScript = pkgs.nix-update-script {};

        tags = ["fts5"];

        meta = with lib; {
          maintainers = with maintainers; [pinpox];
          license = licenses.gpl3;
          description = "Zettelkasten plain text note-taking assistant";
          homepage = "https://github.com/mickael-menu/zk";
          mainProgram = "zk";
        };
      };
    in {
      enable = true;
      package = zk-latest;
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
