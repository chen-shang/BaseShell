#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
# https://stedolan.github.io/jq/manual/
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================================
function json_toString(){
  local param=$*
  _action(){
    local json=$1
    #  --compact-output/ -c：
    #默认情况下，jq pretty-prints JSON输出。通过将每个JSON对象放在一行上，使用此选项将导致输出更紧凑。
    echo "${json}"|jq -c .
  }
  pip "${param}"
}

function json_toPrettyString(){
  local param=$*
  _action(){
    local json=$1
    echo "${json}"|jq .
  }
  pip "${param}"
}

function json_empty(){
  local keys=$*
  local json="{}"
  for k in ${keys};do
    json=$(echo "${json}"|jq .${k}=\"\")
  done
  echo "${json}"
}

function json_new(){
  local criteria="$1"
  local json="{}"
  local kvs=$(echo "${criteria}"|awk -F '&' '{for(i=1;i<=NF;i++){print $i}}')
  local end="====end===="
  echo -e "${kvs}\n${end}"|while read kv;do
    equals "${kv}" "${end}" && echo "${json}"
    local k="$(echo "${kv}"|awk -F '=' '{print $1}')"
    local v="$(echo "${kv}"|awk -F '=' '{print $2}')"
    local type=$(echo ${v}|jq -r 'type' 2>/dev/null )
    case "${type}" in
      "number"|"object"|"array")
        json=$(echo "${json}"|jq -c .${k}="${v}")
      ;;
      *)
        json=$(echo "${json}"|jq -c ".${k}=\"${v}\"")
      ;;
    esac
  done
}