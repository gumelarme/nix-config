{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.modules.todo;
in {
  options.modules.todo = {
    enable = lib.mkEnableOption "Enable todo-txt";
    directory = lib.mkOption {
      type = lib.types.path;
      description = "todo-txt workspace";
      default = "${config.common.sync}/todo";
    };

    configDir = lib.mkOption {
      type = lib.types.path;
      description = "todo-txt config directory";
      default = "${config.common.configHome}/todo-txt";
    };
  };

  config = let
    configFile = "${cfg.configDir}/todo.cfg";
    configActionDir = "${cfg.configDir}/actions";
  in
    lib.mkIf cfg.enable {
      programs.zsh.shellAliases = lib.mkIf config.modules.shell.enable {
        t = "todo.sh -d ${configFile}";
      };

      home.packages = with pkgs; [
        todo-txt-cli
      ];

      home.file = let
        pluginsPath = map (path: ./actions + path) [
          /commit
          /edit
          /pull
          /push
          /sync
          /view
          /revive
        ];
        pathToString = path: lib.lists.last (builtins.split ''/'' (toString path));
        makePlugin = name: path: {
          name = "${configActionDir}/${name}";
          value = {
            executable = true;
            source = path;
          };
        };
        plugins = map (p: makePlugin (pathToString p) p) pluginsPath;
      in
        lib.mkMerge [
          (builtins.listToAttrs plugins)
          {
            "${configFile}".text =
              ''
                export TODO_DIR=${cfg.directory}
                export TODO_FILE="$TODO_DIR/todo.txt"
                export DONE_FILE="$TODO_DIR/done.txt"
                export REPORT_FILE="$TODO_DIR/report.txt"

                # todo.sh without argument
                export TODOTXT_DEFAULT_ACTION="ls"

                # Sort by priority
                export TODOTXT_SORT_COMMAND='env LC_COLLATE=C sort -k 2,2 -k 1,1n'

                # You can customize your actions directory location
                export TODO_ACTIONS_DIR="${configActionDir}"
              ''
              + "\n"
              + (builtins.readFile ./color.cfg);
          }
        ];
    };
}
