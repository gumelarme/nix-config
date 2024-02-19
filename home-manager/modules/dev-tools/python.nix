{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev-tools.python;
in {
  options.modules.dev-tools.python = {
    enable = mkEnableOption "Enable python development tools";
    package = mkOption {
      type = types.package;
      default = pkgs.python3Full;
      description = "Python package to install, default will follow nix stable version";
    };

    pyenv = {
      enable = mkEnableOption "Enable pyenv";
      rootDirectory = mkOption {
        type = types.path;
        description = "Path to set PYENV_ROOT";
      };
    };
  };

  config = mkIf cfg.enable {
    # pyenv init script load every time new shell is created, it make shell load very slow
    # here its just as an alias, use it whenever it needed
    # TODO: pyenv prompt will be disabled by default in future, remove that line when that happen
    programs.zsh.initExtra = mkIf cfg.pyenv.enable ''
      export PYENV_VIRTUALENV_DISABLE_PROMPT=1
      export PYENV_ROOT="${cfg.pyenv.rootDirectory}"
      alias pyenv-init='eval "$(${getExe pkgs.pyenv} init - zsh)"'
    '';

    home.packages = mkMerge (with pkgs; [
      (mkIf cfg.pyenv.enable [pyenv])
      [
        cfg.package
        poetry
        black
        isort
        pipenv
        nodePackages.pyright
      ]
    ]);
  };
}
