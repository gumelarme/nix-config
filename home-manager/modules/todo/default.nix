{
  lib,
  pkgs,
  config,
  ...
}: {
  config = let
  
    configLocation = "${config.xdg.configHome}/todo-txt/todo.cfg";
  in {
    home.file."${configLocation}".text =
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
        # export TODO_ACTIONS_DIR="$HOME/.todo.actions.d"
      ''
      + "\n"
      + (builtins.readFile ./color.cfg);

    home.packages = with pkgs; [
      todo-txt-cli
    ];

    programs.zsh.shellAliases = lib.mkIf config.modules.shell.enable {
      t = "todo.sh -d ${configLocation}";
    };
  };
}
