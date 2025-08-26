{
  prefix,
  pkgs,
  lib,
  ...
}: let
  jq = lib.getExe pkgs.jq;
  http = "${pkgs.httpie}/bin/http";
  v2raya_address = "http://localhost:2017/api";
  session_file = "/tmp/v2raya-switchy-session";
in
  pkgs.writeShellScriptBin "${prefix}-switchy" ''
    MODE=''${1:-"gfwlist"}
    IS_RESET=''${2:-""} # TODO: check reset as a flag instead of literal arguments

    if [[ "$IS_RESET" == "reset" ]]; then
      rm ${session_file}
    fi

    if [ ! -f ${session_file} ]; then
      # Read Password
      echo "Please login"

      echo -n "Username: "
      read username

      echo -n "Password: "
      read -s password
      echo
      echo "Logging in..."

      login_response=$(${http} POST "${v2raya_address}/login" username=$username password=$password)
      login_result=$(echo $login_response | ${jq} .code -r)
      if [[ "$login_result" == "SUCCESS" ]]; then
        echo "Login success"
        echo $login_response | ${jq} .data.token -r > ${session_file}
      else
        echo "Login failed"
        echo $login_response | ${jq} .message
        exit 1
      fi
    else
      echo "Using existing session"
    fi

    # Changing system proxy mode
    echo "switching system proxy to '$MODE'"
    change_setting_response=$(${http} PUT "${v2raya_address}/setting" -A bearer -a $(cat ${session_file}) transparent=$MODE)
    change_setting_result=$(echo $change_setting_response | ${jq} .code -r)

    if [[ "$change_setting_result" != "SUCCESS"  ]]; then
      echo -n "Error: "
      echo $change_setting_response | ${jq} .message -r
      exit 1
    fi

    echo "Done!"

  ''
