#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2086
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ../../BaseShell/Starter/BaseHeader.sh
#导入工具包
#===============================================================================
function list_add(){ :
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$(eval echo '$'"{#${listName}[@]}")
  local cmd="${listName}[${size}]=$1"
  eval "${cmd}"
}

function list_removeById(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="unset ${listName}[$1]"
  eval "${cmd}"
}

function list_removeByValue(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd="unset ${listName}[$1]"
}

function list_get(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[$1]}"
  eval echo "${cmd}"
}

function list_forEach(){
  local runnable=$1
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  local values=$(eval echo "${cmd}")
  for value in ${values};do
     eval "${runnable} ${value}"
  done
}

function list_size(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{#${listName}[@]}"
  eval echo "${cmd}"
}

function list_isEmpty(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$(eval echo '$'"{#${listName}[@]}")
  equals "${size}" "0" && return "${TRUE}" || return "${FALSE}"
}

function list_contains(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  local values=$(eval echo "${cmd}")
  for value in ${values};do
    equals "${value}" "$1" && return "${TRUE}"
  done

  return "${FALSE}"
}

function list_clear(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  eval "unset ${listName}"
}

function list_indexOf(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$(eval echo '$'"{#${listName}[@]}")
  local result=-1
  for ((index=0;index<size;index++));do
    local cmd='$'"{${listName}[${index}]}"
    local value=$(eval echo "${cmd}")
    equals "${value}" "$1" && {
      result="${index}" && break
    }
  done

  echo "${result}"
}
function list_lastIndexOf(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local size=$(eval echo '$'"{#${listName}[@]}")
  local result=-1
  for ((index=size;0<=index;index--));do
    local cmd='$'"{${listName}[${index}]}"
    local value=$(eval echo "${cmd}")
    equals "${value}" "$1" && {
      result="${index}" && break
    }
  done
  echo "${result}"
}
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
function list_copy(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  eval echo "${cmd}"
}

function list_values(){
  local listName=$(echo "${FUNCNAME[0]}"|awk -F '_' '{print $1}')
  local cmd='$'"{${listName}[@]}"
  eval echo "${cmd}"
}

declare -a list=()
function new_arrayList(){ _NotBlank "$1" "arrayList name can not be null"
  local listName=$1
  local cmd="${listName}=()"
  eval declare -a "${cmd}"

  local functions=$(cat < "${BASH_SOURCE[0]}"|grep -v "grep"|grep "function "|grep -v "new_function"|grep "(){"| sed "s/(){//g" |awk  '{print $2}')

  for func in ${functions} ;do
     local suffix=$(echo "${func}"|awk -F '_' '{print $2}')
     new_function "${func}" "${listName}_${suffix}"
  done
}
