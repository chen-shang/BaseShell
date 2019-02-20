#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Constant/BaseConstant.sh
#===============================================================

# @return {@code true} if the arguments are equal to each other
function equals(){
  local value1=$1 #一参
  local value2=$2 #二参
  [[ "${value1}" == "${value2}" ]] && return "${TRUE}" || return "${FALSE}"
}

# @param timeout the maximum time to wait in seconds.
function delay(){
  local timeout=$1
  sleep "${timeout}"
}

# isEmpty ""  -> 0
# isEmpty " " -> 1
# isEmpty "1" -> 1
# isEmpty  1  -> 1
function isEmpty(){
  local param=$1
  # if[[ -z ${value} ]] 中 -z 代表判断字符串的长度是否为0
  [[ -z "${param}" ]] && return "${TRUE}" || return "${FALSE}"
}
function isNotEmpty(){
  local param=$1
  ! isEmpty "${param}"
}

# isBlank ""  -> 0
# isBlank " " -> 0
# isBlank "1" -> 1
# isBlank  1  -> 1
function isBlank(){
  local param=$(echo "$1" | tr -d " ")
  $(isEmpty "${param}") && return "${TRUE}" || return "${FALSE}"
}

function isNotBlank(){
  local param=$(echo "$1" | tr -d " ")
  ! isBlank "${param}"
}

function hashCode(){
  local param=$1
  local hash=0
  for (( i = 0; i < ${#param}; i ++ )); do
    printf -v val "%d" "'${param:$i:1}" # val is ASCII val
    if ((31 * hash + val > 2147483647)); then
      # hash scheme
      hash=$((- 2147483648 + ( 31 * hash + val ) % 2147483648))
    elif ((31 * hash + val < - 2147483648)); then
      hash=$((2147483648 - ( 31 * hash + val ) % 2147483648))
    else
      hash=$((31 * hash + val))
    fi
  done
  printf "%d" "${hash}" # final hashCode in decimal
}