{
  prefix,
  pkgs,
  ...
}: let
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  satty = "${pkgs.satty}/bin/satty";
in
  # TODO: qualify niri, jq, wl-paste
  pkgs.writeShellScriptBin "${prefix}-snap" ''
    set -o errexit
    set -o pipefail
    set -o nounset

    MODE="''${1:-region}"

    case "''${MODE}" in
    region)
      ${grim} -g "$(${slurp} -d)" -
      ;;

    window)
      niri msg action screenshot-window
      sleep 0.5
      wl-paste --type image/png
      ;;

    monitor-focused)
      ${grim} -o "$(niri msg --json focused-output | jq --raw-output .name)" -
      ;;

    monitor-all)
      ${grim} -
      ;;

    *)
      echo "''${MODE} is not a supported, aborting!" >&2
      echo "available options: region, window, monitor-focused, monitor-all" >&2
      exit 1
      ;;

    esac | ${satty} --filename -
  ''
