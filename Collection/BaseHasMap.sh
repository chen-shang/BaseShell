#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2034,SC2086
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ../../BaseShell/Starter/BaseHeader.sh
source ./../../BaseShell/Collection/BaseMap.sh

declare -A hashMap=()
readonly defaultSize=2
function new_hashMap(){ _NotBlank "$1" "hash map name can not be null"
  local mapName=$1

  local functions=$(cat < "${BASH_SOURCE[0]}"|grep -v "grep"|grep "function "|grep -v "new_function"|grep "(){"| sed "s/(){//g" |awk  '{print $2}')

  for func in ${functions} ;do
     local suffix=$(echo "${func}"|awk -F '_' '{print $2}')
     new_function "${func}" "${mapName}_${suffix}"
  done
#  eval "${mapName}_clear"
}

function hashMap_get(){ _NotBlank "$1" "key can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local key=$1
  local hashCode=$(echo "${key}"|hashCode)
  local size=$(private_size $(${mapName}_size))
  local index=$((hashCode % size))
  local cmd='$'"{${mapName}[${index}]}"

  map_clear
  eval "declare -A map=( $(eval echo ${cmd}) )"
  map_get "${key}"
}

function hashMap_containsKey(){ _NotBlank "$1" "key can not be blank"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="${mapName}_get $1"
  local value=$(eval ${cmd})
  isNotBlank "${value}" && return ${TRUE} || return ${FALSE}
}

function hashMap_containsValue(){ _NotBlank "$1" "value can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local values=$(${mapName}_values)
  for value in ${values};do
    ! equals "${value}" "$1" && continue || return "${TRUE}"
  done
  return "${FALSE}"
}

function hashMap_remove(){ _NotBlank "$1" "key can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  log_error "不支持移除,否则还得缩容"
}
function hashMap_size(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  eval "declare -A kv=( $(${mapName}_kv) )"
  echo "${#kv[@]}"
}
function hashMap_forEach(){ _NotBlank "$1" "function can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')

  for key in $(${mapName}_keys);do
    local value=$(${mapName}_get "${key}")
    $1 ${key} ${value}
  done
}
function hashMap_isEmpty(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$(${mapName}_size)
  equals "${size}" "0" && return ${TRUE} || return ${FALSE}
}
function hashMap_keys(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  eval "declare -A kv=( $(${mapName}_kv) )"
  echo "${!kv[@]}"
}
function hashMap_values(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  eval "declare -A kv=( $(${mapName}_kv) )"
  echo "${kv[@]}"
}
function hashMap_kv(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${mapName}[@]}"
  eval echo "${cmd}"
}

function hashMap_toString(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  ${mapName}_kv
}

private_putVal(){
  local mapName=$1

  local index=$2
  local newKey=$3
  local newValue=$4

  local cmd='$'"{${mapName}[${index}]}"
  local v=$(eval echo ${cmd})
  isBlank "${v}" && {
    local cmd="${mapName}[${index}]=[${newKey}]=${newValue}"
    eval ${cmd}
  }

  isBlank "${v}" || {
    local cmd='$'"{${mapName}[${index}]}"
    new_map bucket
    eval "declare -A bucket=($(eval echo "${cmd}"))"
    bucket_put "${newKey}" "${newValue}"
    local bucketKv=$(bucket_kv)
    local cmd="${mapName}[${index}]='${bucketKv}'"
    eval ${cmd}
  }
}

private_rehash(){
  local mapName=$1;local size=$2
  local kv=$(${mapName}_kv)
  new_map kvs
  eval "declare -A kvs=(${kv})"

  local cmd="${mapName}=()"
  eval "${cmd}"
  for k in ${!kvs[@]};do
    local v=$(kvs_get "${k}")
    local hashCode=$(echo "${k}"|hashCode)
    local index=$((hashCode % size))
    private_putVal "${mapName}" "${index}" "${k}" "${v}"
  done
}

function hashMap_put(){ _NotBlank "$1" "key can not be null" && _NotBlank "$2" "value can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')

  local key=$1 ; local value=$2
  local nowSize=$(${mapName}_size)
  local size=$(private_size ${nowSize})
  local hashCode=$(echo "${key}"|hashCode)
  local index=$((hashCode % size))

  if [[ ${nowSize} -ge ${defaultSize} ]];then
     local log2=$(private_log2 ${nowSize})
     local decimal=$(echo "${log2}"|awk -F '.' '{print $2}')
     isBlank "${decimal}" && {
       private_rehash "${mapName}" "${size}"
     }
  fi

  private_putVal  "${mapName}" "${index}" "${key}" "${value}"
}

private_log2(){
  awk "BEGIN { result=log($1)/log(2); print result }"
}

private_size(){
  local size=$1
  if [[ ${size} -lt ${defaultSize} ]];then
    echo "${defaultSize}"
    return
  fi

  local log2=$(private_log2 "${size}")
  # 整数部分
  local integer=$(echo ${log2}|awk -F '.' '{print $1}')
  echo $((2**$((integer+1))))
}
