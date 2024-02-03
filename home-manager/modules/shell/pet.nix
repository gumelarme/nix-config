{config, ...}: {
  # command line snippet manager
  programs.pet = {
    # TODO: configure gists
    enable = true;
    settings = {
      General = {
        editor = "vim";
        selectcmd = "fzf --ansi";
      };
    };
    snippets = [
      {
        command = let
          username = config.home.username;
          host = config.home.sessionVariables.HOSTNAME;
        in "home-manager switch -b backup --flake .#${username}@${host}";
        description = "Rebuild home-manager configuration";
        tag = ["nix"];
      }

      {
        command = "nix-collect-garbage -d";
        description = "Purge unused packaged";
        tag = ["nix"];
      }

      {
        command = "nix-env --delete-generations 7d && nix-store --gc";
        description = "Purge unused packaged older than a week";
        tag = ["nix"];
      }

      {
        command = "nix-hash --flat --type sha256 --sri";
        description = "Purge unused packaged older than a week";
        tag = ["nix"];
      }
    ];
  };
}
