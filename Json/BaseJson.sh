#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseHeader.sh
#===============================================================
function json.format(){
  local param=$1
  _action(){ _NotNull "$1" "json can not be null"
    local param=$1
    echo "${param}"|jq .
  }
  pip "${param}"
}

function json.get(){ _NotNull "$1" "json can not be null" && _NotNull "$2" "param name can not be null"
  local json=$1
  local name=$2
  echo "${json}"|jq .
}


#===============================================================
