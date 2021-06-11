#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2086
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================} 
declare -a list=()
# 新建一个arrayList []<-(listName:String)
function new_arrayList(){ _NotBlank "$1" "arrayList name can not be null"
  local listName=$1
  local cmd="${listName}=()"
  eval declare -a "${cmd}"
  local functions=$(cat < "${BASH_SOURCE[0]}"|grep -v "grep"|grep "function "|grep -v "new_function"|grep "(){"| sed "s/(){//g" |awk  '{print $2}')
  local func;for func in ${functions} ;do
     local suffix=$(echo "${func}"|awk -F '_' '{print $2}')
     new_function "${func}" "${listName}_${suffix}"
  done
}
# 添加元素 []<-(item:String)
function list_add(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$(eval echo '$'"{#${listName}[@]}")
  local cmd="${listName}[${size}]='$1'"
  eval "${cmd}"
}
# 指定位置设置元素 []<-(index:Integer,item:String)
function list_set(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="${listName}[$1]='$2'"
  eval "${cmd}"
}
# 移除指定位置元素 []<-(index:Integer)
function list_removeByIndex(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="unset ${listName}[$1]"
  eval "${cmd}"
}
# 移除指定value元素 []<-(value:String)
function list_removeByValue(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  # todo
  local cmd="unset ${listName}[$1]"
  eval "${cmd}"
}
# 获取指定位置元素 []<-(index:int)
function list_get(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  local values=($(eval echo "${cmd}"))
  echo "${values[$1]}"
}
# 针对每一个元素执行操作 []<-(runnable:Function[item:String])
function list_forEach(){
  local runnable=$1
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  local values=$(eval echo "${cmd}")
  local value;for value in ${values};do
     eval "${runnable} ${value}"
  done
}
# 列表中元素的个数 [int]<-()
function list_size(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{#${listName}[@]}"
  eval echo "${cmd}"
}
# 列表是否为空 [boolean]<-()
function list_isEmpty(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$(eval echo '$'"{#${listName}[@]}")
  equals "${size}" "0" && return "${TRUE}" || return "${FALSE}"
}
# 列表是否包含指定元素 [boolean]<-(item:String)
function list_contains(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  local values=$(eval echo "${cmd}")
  local value;for value in ${values};do
    equals "${value}" "$1" && return "${TRUE}"
  done

  return "${FALSE}"
}
# 清空list
function list_clear(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="${listName}=()"
  eval "${cmd}"
}
# 获取指定元素的下标,从前往后
function list_indexOf(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$(eval echo '$'"{#${listName}[@]}")
  local result=-1
  local index;for ((index=0;index<size;index++));do
    local cmd='$'"{${listName}[${index}]}"
    local value=$(eval echo "${cmd}")
    equals "${value}" "$1" && {
      result="${index}" && break
    }
  done

  echo "${result}"
}
# 获取指定元素的下标,从后往前
function list_lastIndexOf(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$(eval echo '$'"{#${listName}[@]}")
  local result=-1
  local index;for ((index=size;0<=index;index--));do
    local cmd='$'"{${listName}[${index}]}"
    local value=$(eval echo "${cmd}")
    equals "${value}" "$1" && {
      result="${index}" && break
    }
  done
  echo "${result}"
}
# 截取指定元素的下标 [list]<-(from:String,to:String)
function list_sub(){ _NotBlank "$1" "from can not be null"
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local from=$1
  local to=$2
  isBlank "${to}" && {
    local cmd='$'"{${listName}[@]:${from}}"
    eval echo "${cmd}"
  }

  isNotBlank "${to}" && {
    local cmd='$'"{${listName}[@]:${from}:${to}}"
    eval echo "${cmd}"
  }
}
# 拷贝返回一个新的list
function list_copy(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  eval echo "${cmd}"
}
# list的value集合
function list_values(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  eval echo "${cmd}"
}
# 对应java中的Stream.map操作
function list_mapper(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  local values=$(eval echo "${cmd}")
  local result=""
  local value;for value in ${values};do
     result+="$(eval $1 "${value}") "
  done

  echo "${result}"
}
# 对应java中的Stream.reduce操作
function list_reducer(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  local values=$(eval echo "${cmd}")
  
  local result=$2
  # 含有初始值
  isNotBlank "${result}" && {
    local value;for value in ${values};do
      result=$(eval "$1" "${result}" "${value}")
    done
  }

  # 不含初始值
  isBlank "${result}" && {
    local size=$(${listName}_size)
    result=$(${listName}_get 0)
    local i;for ((i=1;i<size;i++)){
      local value=$(${listName}_get "${i}")
      result=$(eval "$1" "${result}" "${value}")
    }
  }

  echo "${result}"
}
