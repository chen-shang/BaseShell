#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseHeader.sh
#===============================================================

# 字符串长度
function string_length(){
  local string=$1
  echo "${#string}"
}

# string_isEmpty ""  -> 0
# string_isEmpty " " -> 1
# string_isEmpty "1" -> 1
# string_isEmpty  1  -> 1
# 判断一个字符串是否为空
function string_isEmpty(){
  local string=$1
  $(isEmpty "${string}") && echo "${TRUE}" || echo "${FALSE}"
}

# string_isNotEmpty ""  -> 1
# string_isNotEmpty " " -> 0
# string_isNotEmpty "1" -> 0
# string_isNotEmpty  1  -> 0
# 判断一个字符串是否不为空
function string_isNotEmpty(){
  local string=$1
  $(isNotEmpty "${string}") && echo "${TRUE}" || echo "${FALSE}"
}

# string_isBlank ""  -> 0
# string_isBlank " " -> 0
# string_isBlank "1" -> 1
# string_isBlank  1  -> 1
# 判断一个字符串是否为空
function string_isBlank(){
  $(isBlank "$1") && echo  "${TRUE}" || echo "${FALSE}"
}

# string_isNotBlank ""  -> 1
# string_isNotBlank " " -> 1
# string_isNotBlank "1" -> 0
# string_isNotBlank  1  -> 0
# 判断一个字符串是否不为空
function string_isNotBlank(){
  $(isNotBlank "$1") && echo "${TRUE}" || echo "${FALSE}"
}

# 去掉字符串前后空格
function string_trim(){
  echo $(echo "$1") #可去掉首尾的空格
}

# 转大写
function string_toUpperCase(){
  echo "$1" | tr '[:lower:]' '[:upper:]'
}

# 转小写
function string_toLowerCase(){
  echo "$1" | tr '[:upper:]' '[:lower:]'
}

# 判断两个字符串是否相等
function string_equals(){
  local value1=$1 #一参
  local value2=$2 #二参
  [[ "${value1}" == "${value2}" ]] && echo "${TRUE}" || echo "${FALSE}"
}

# 判断两个字符串是否相等
function string_notEquals(){
  local value1=$1 #一参
  local value2=$2 #二参
  [[ "${value1}" == "${value2}" ]] && echo "${FALSE}" || echo "${TRUE}"
}

# 判断两个字符串是否相等,忽略大小写
function string_equalsIgnoreCase(){
  local value1=$(string_toUpperCase "$1");
  local value2=$(string_toUpperCase "$2")
  string_equals "${value1}" "${value2}"
}

# 连接两个字符串
function string_join(){
  local value1=$1;
  local value2=$2
  echo "${value1}${value2}"
}

# 查看首字母
function string_startsWith(){
  local value1=$1;
  local value2=$2
  [[ "${value1}" == "${value2}"* ]] && echo "${TRUE}" || echo "${FALSE}"
}

# 查看尾字母
function string_endsWith(){
  local value1=$1;
  local value2=$2
  [[ "${value1}" == *"${value2}" ]] && echo "${TRUE}" || echo "${FALSE}"
}

# 字符串包含
function string_contains(){
  local value1=$1;
  local value2=$2
  [[ ${value1} =~ ${value2} ]] && echo "${TRUE}" || echo "${FALSE}"
}

# 判断是否是自然数
function string_isNatural(){
  local param=$1
  [[ $(grep '^[[:digit:]]*$' <<<"${param}") ]] && echo "${TRUE}" || echo "${FALSE}"
}

# 字符串下标所在位置的字符
function string_indexOf(){
  local param=$1
  local index=$2
  echo ${param:${index}:1}
}

# 字符串下标所在位置的字符
function string_lastIndexOf(){
  local param=$1
  local index=$2
  echo ${param:0-${index}:1}
}

function string_subString(){
  local param=$1 #传入的字符串
  if [[ $# -eq 2 ]];then
    local begin=$2 #起始位置
    echo ${param:${begin}}
  elif [[ $# -eq 3 ]];then
    local begin=$2 #起始位置
    local end=$3
    echo ${param:${begin}:$(( $end - $begin + 1))}
  fi
}