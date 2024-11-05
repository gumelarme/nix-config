{lib, ...}:
with lib; let
  mkPathOption = desc:
    mkOption {
      type = types.path;
      description = desc;
    };
in {
  options.common = {
    sync = mkPathOption "Sync folder";
    screenshot = mkPathOption "Screenshot folder";
    configHome = mkPathOption "Config home folder";
  };
}
