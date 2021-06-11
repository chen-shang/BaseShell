#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2034,SC2068,SC2154
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/Collection/BaseMap.sh
#===============================================================================
readonly defaultSize=32

declare -A hashMap=()
# 新建一个HashMap  []<-(mapName:String)
function new_hashMap(){ _NotBlank "$1" "hash map name can not be null"
  local mapName=$1
  local functions=$(cat < "${BASH_SOURCE[0]}"|grep -v "grep"|grep "function "|grep -v "new_function"|grep "(){"| sed "s/(){//g" |awk  '{print $2}')
  local func;for func in ${functions} ;do
     local suffix=$(echo "${func}"|awk -F '_' '{print $2}')
     new_function "${func}" "${mapName}_${suffix}"
  done
  # 先清空map
  eval "${mapName}_clear"
}
# 清空HashMap
function hashMap_clear(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="${mapName}=()"
  eval "${cmd}"
}
# 获取HashMap元素 [String]<-(key:String)
function hashMap_get(){ _NotBlank "$1" "key can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local key=$1
  local hashCode=$(echo "${key}"|hashCode)
  local nowSize=$(eval "${mapName}"_size)
  local size=$(private_size "${nowSize}")

  # 当前是满的时候,还没有来来得及扩容
  if [[ $((nowSize*2)) -eq ${size} ]];then
    size=nowSize
  fi

  local index=$((hashCode % size))
  local cmd='$'"{${mapName}[${index}]}"

  map_clear
  eval "map=($(eval echo "${cmd}"))"
  map_get "$1"
}
# 是否制定包含某key [boolean]<-(key:String)
function hashMap_containsKey(){ _NotBlank "$1" "key can not be blank"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local value=$(eval "${mapName}_get $1")
  isNotBlank "${value}" && return "${TRUE}" || return "${FALSE}"
}
# 是否制定包含某value [boolean]<-(key:String)
function hashMap_containsValue(){ _NotBlank "$1" "value can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local values=$(eval "${mapName}_values")
  local value;for value in ${values};do
    ! equals "${value}" "$1" && continue || return "${TRUE}"
  done
  return "${FALSE}"
}
# 移除某key,暂时不支持
function hashMap_remove(){ _NotBlank "$1" "key can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  log_error "now do not support remove element!!!!!!"
}

# HashMap中元素的个数
function hashMap_size(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  eval "declare -A kv=( $("${mapName}_kv") )"
  echo "${#kv[@]}"
}
# 针对(k,v)进行处理 []<-(func:Function[k:String,v:String])
function hashMap_forEach(){ _NotBlank "$1" "function can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local func=$1
  local key;for key in $("${mapName}"_keys);do
    local value=$(eval "${mapName}_get ${key}")
    eval "${func} ${key} ${value}"
  done
}
# HashMap是否为空
function hashMap_isEmpty(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$("${mapName}_size")
  equals "${size}" "0" && return "${TRUE}" || return "${FALSE}"
}
# HashMap的key列表
function hashMap_keys(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  eval "declare -A kv=( $("${mapName}_kv") )"
  echo "${!kv[@]}"
}
# HashMap的value列表
function hashMap_values(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  eval "declare -A kv=( $("${mapName}_kv") )"
  echo "${kv[@]}"
}
# HashMap的kv列表
function hashMap_kv(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${mapName}[@]}"
  eval echo "${cmd}"
}
# toString调用hashMap_kv方法
function hashMap_toString(){
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  eval "${mapName}_kv"
}
# put元素 []<-(k:String,v:String)
function hashMap_put(){ _NotBlank "$1" "key can not be null" && _NotBlank "$2" "value can not be null"
  local mapName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')

  local key=$1 ; local value=$2
  local nowSize=$(eval "${mapName}"_size)
  local size=$(private_size "${nowSize}")
  local hashCode=$(echo "${key}"|hashCode)
  local index=$((hashCode % size))

  # 大于初始值的时候才进行扩缩容
  if [[ ${nowSize} -ge ${defaultSize} ]];then
     # 并且满了就开始扩容
     if [[ $((nowSize*2)) -eq ${size} ]];then
       private_rehash "${mapName}" "${size}"
     fi
  fi

  private_putVal  "${mapName}" "${index}" "${key}" "${value}"
}

private_size(){ _NotBlank "$1" "now size can not be null"
  local size=$1
  if [[ ${size} -lt ${defaultSize} ]];then
    echo "${defaultSize}"
    return
  fi

  local log2=$(awk "BEGIN { result=log(${size})/log(2); print result }")
  # 整数部分
  local integer=$(echo "${log2}"|awk -F '.' '{print $1}')
  echo $((2**$((integer+1))))
}


private_putVal(){ _NotBlank "$1" "mapName can not be null" &&  _NotBlank "$2" "index can not be null" &&  _NotBlank "$3" "key can not be null"&&  _NotBlank "$4" "value can not be null"
  local mapName=$1 ; local index=$2 ;local key=$3 ;local value=$4

  local cmd='$'"{${mapName}[${index}]}"
  local v=$(eval echo "${cmd}")
  isBlank "${v}" && {
    local cmd="${mapName}[${index}]=[${key}]=${value}"
    eval "${cmd}"
  }

  isBlank "${v}" || {
    local cmd='$'"{${mapName}[${index}]}"
    new_map bucket
    eval "declare -A bucket=($(eval echo "${cmd}"))"
    bucket_put "${key}" "${value}"
    local bucketKv=$(bucket_kv)
    local cmd="${mapName}[${index}]='${bucketKv}'"
    eval "${cmd}"
  }
}

private_rehash(){
  local mapName=$1;local size=$2
  local kv=$("${mapName}"_kv)
  new_map kvs
  eval "declare -A kvs=(${kv})"

  local cmd="${mapName}=()"
  eval "${cmd}"
  local k;for k in ${!kvs[@]};do
    local v=$(kvs_get "${k}")
    local hashCode=$(echo "${k}"|hashCode)
    local index=$((hashCode % size))
    private_putVal "${mapName}" "${index}" "${k}" "${v}"
  done
}

