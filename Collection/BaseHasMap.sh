#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2034,SC2086
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ../../BaseShell/Starter/BaseHeader.sh

function hashMap_put(){ _NotBlank "$1" "key can not be null" && _NotBlank "$2" "value can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}
function hashMap_get(){ _NotBlank "$1" "key can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}

function hashMap_containsKey(){ _NotBlank "$1" "key can not be blank"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}

function hashMap_containsValue(){ _NotBlank "$1" "value can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}

function hashMap_remove(){ _NotBlank "$1" "key can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}
function hashMap_size(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}

function hashMap_forEach(){ _NotBlank "$1" "function can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}
function hashMap_isEmpty(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}
function hashMap_keys(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}
function hashMap_values(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}
function hashMap_kv(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}

function hashMap_toString(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
}

declare -A new_hashMap=()
function new_hashMap(){ _NotBlank "$1" "mapName can not be null"
  local mapName=$1
  local cmd="${mapName}=()"
  eval declare -A "${cmd}"

  local functions=$(cat < "${BASH_SOURCE[0]}"|grep -v "grep"|grep "function "|grep -v "new_function"|grep "(){"| sed "s/(){//g" |awk  '{print $2}')

  for func in ${functions} ;do
     local suffix=$(echo "${func}"|awk -F '_' '{print $2}')
     new_function "${func}" "${mapName}_${suffix}"
  done
}