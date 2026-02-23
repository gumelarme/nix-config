{config, ...}: {
  # command line snippet manager
  programs.pet = {
    # TODO: configure gists
    enable = true;
    settings = {
      General = {
        color = true;
        editor = "vim";
        selectcmd = "fzf --ansi";
        format = "$command // $description $tags";
      };
    };
    snippets = let
      uname = config.home.username;
      host = config.home.sessionVariables.HOSTNAME;
    in [
      {
        command = "home-manager switch -b backup --flake .\\#${uname}@${host}";
        description = "Rebuild home-manager configuration";
        tag = [
          "nix"
          "home-manager"
        ];
      }

      {
        command = "sudo nixos-rebuild switch --flake .\\#${host}";
        description = "Rebuild nixos";
        tag = ["nix"];
      }

      {
        command = "nix-rebuild list-generations";
        description = "List nix generations";
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
        description = "Get nix checksum from link";
        tag = ["nix"];
      }

      # Dev tools
      {
        command = "echo \"use flake\" >> .envrc && direnv allow .";
        description = "Activate nix env";
        tag = [
          "nix"
          "direnv"
        ];
      }
    ];
  };
}
