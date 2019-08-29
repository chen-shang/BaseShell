#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2034,SC2086
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ../../BaseShell/Starter/BaseHeader.sh

function map_put(){ _NotBlank "$1" "key can not be null" && _NotBlank "$2" "value can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="${mapName}[$1]=$2"
  eval "${cmd}"
}
function map_get(){ _NotBlank "$1" "key can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="{${mapName}[$1]}"
  eval echo '$'"${cmd}"
}

function map_containsKey(){ _NotBlank "$1" "key can not be blank"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="{${mapName}[$1]}"
  local result=$(eval echo '$'"${cmd}")
  isNotBlank "${result}"
}

function map_containsValue(){ _NotBlank "$1" "value can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local values=$(eval echo '$'"{${mapName}[@]}")
  for value in ${values};do
    ! equals "${value}" "$1" && continue || return "${TRUE}"
  done
  return "${FALSE}"
}

function map_remove(){ _NotBlank "$1" "key can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="${mapName}[$1]"
  eval unset "${cmd}"
}
function map_size(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  eval echo '$'"{#${mapName}[@]}"
}

function map_forEach(){ _NotBlank "$1" "function can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="{!${mapName}[@]}"
  local keys=$(eval echo '$'"${cmd}")

  for key in ${keys};do
    cmd="{${mapName}[${key}]}"
    local value=$(eval echo '$'"${cmd}")
    eval "$1 ${key} ${value}"
  done
}
function map_isEmpty(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$(eval echo '$'"{#${mapName}[@]}")
  equals "${size}" 0 && return "${TRUE}" || return "${FALSE}"
}
function map_keys(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="{!${mapName}[@]}"
  eval echo '$'"${cmd}"
}
function map_values(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  eval echo '$'"{${mapName}[@]}"
}

declare -A map=()
function new_map(){ _NotBlank "$1" "mapName can not be null"
  local mapName=$1
  local cmd="${mapName}=()"
  eval declare -A "${cmd}"

  local functions=$(cat < "${BASH_SOURCE[0]}"|grep -v "grep"|grep "function "|grep -v "new_function"|grep "(){"| sed "s/(){//g" |awk  '{print $2}')

  for func in ${functions} ;do
     local suffix=$(echo "${func}"|awk -F '_' '{print $2}')
     new_function "${func}" "${mapName}_${suffix}"
  done
}