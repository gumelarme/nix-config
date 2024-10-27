{
  lib,
  pkgs,
  config,
  ...
}: {
  config = let
    configDir = "${config.xdg.configHome}/todo-txt";
    configActionDir = "${configDir}/actions";
    configFile = "${configDir}/todo.cfg";
  in {
    home.packages = with pkgs; [
      todo-txt-cli
    ];

    programs.zsh.shellAliases = lib.mkIf config.modules.shell.enable {
      t = "todo.sh -d ${configFile}";
    };

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
              export TODO_DIR=${config.xdg.userDirs.extraConfig.XDG_SYNC_DIR}/todo
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
