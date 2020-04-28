#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
# https://stedolan.github.io/jq/manual/
#===============================================================
import="$(basename "${BASH_SOURCE[0]}" .sh)_$$"
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#导入工具包
#===============================================================================
json_toString(){
  local param=$*
  _action(){
    local json=$1
    #  --compact-output/ -c：
    #默认情况下，jq pretty-prints JSON输出。通过将每个JSON对象放在一行上，使用此选项将导致输出更紧凑。
    echo "${json}"|jq -c .
  }
  pip "${param}"
}

json_toPrettyString(){
  local param=$*
  _action(){
    local json=$1
    echo "${json}"|jq .
  }
  pip "${param}"
}

json_empty(){
  local keys=$*
  local json="{}"
  for k in ${keys};do
    json=$(echo "${json}"|jq .${k}=\"\")
  done
  echo "${json}"
}

json_new(){
  array=$*
  local json="{}"
  for kv in ${array};do
   k=$(echo "${kv}"|awk -F '=' '{print $1}')
   v=$(echo "${kv}"|awk -F '=' '{print $2}')
   local type=$(echo "${v}"|jq -r 'type' 2>/dev/null )
   case ${type} in
     "number"|"object"|"array")
       json=$(echo "${json}"|jq -c .${k}=${v})
     ;;
     *)
       json=$(echo "${json}"|jq -c .${k}=\"${v}\")
     ;;
   esac
  done
  echo "${json}"
}