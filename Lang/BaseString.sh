#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Lang/BaseObject.sh

# 字符串长度 [Int]<-(param:String)
function length(){
  local param=$*
  _action(){
    local param=$*
    echo "${#param}"
  }
  pip "${param}"
}

# 去掉字符串前后空格 [String]<-(param:String)
function trim(){
  local param=$*
  _action(){
    local param=$*
    echo -e $(echo "${param}")
  }
  pip "${param}"
}

# 转大写
function toUpperCase(){
  _action(){
    echo "$*" | tr '[:lower:]' '[:upper:]'
  }
  pip "$*"
}

# 转小写
function toLowerCase(){
  _action(){
    echo "$*" | tr '[:upper:]' '[:lower:]'
  }
  local param=$*
  pip "$*"
}

# 判断两个字符串是否相等
function string_equals(){
  local value1=$1 #一参
  local value2=$2 #二参
  [[ "${value1}" == "${value2}" ]] && return ${TRUE} || return "${FALSE}"
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
  local param=$*
  _action(){
    local param=$*
    (echo "${param}"|grep -q '^[[:digit:]]*$') && echo "${TRUE}"|| echo "${FALSE}"
  }
  pip "${param}"
}

# 字符串下标所在位置的字符
function string_indexOf(){
  local param=$1
  local index=$2
  echo "${param:${index}:1}"
}

# 字符串下标所在位置的字符
function string_lastIndexOf(){
  local param=$1
  local index=$2
  echo "${param:0-${index}:1}"
}

function string_subString(){
  local param=$1 #传入的字符串
  if [[ $# -eq 2 ]];then
    local begin=$2 #起始位置
    echo "${param:${begin}}"
  elif [[ $# -eq 3 ]];then
    local begin=$2 #起始位置
    local end=$3
    echo "${param:${begin}:$((end-begin + 1))}"
  fi
}
function string_firstLetter_toUpperCase(){
  local param=$1 #传入的字符串
  _action(){
    local param=$*
    echo "$(string_indexOf "${param}" "0"|trim|toUpperCase)$(string_subString "${param}" "1")"
  }
  pip "${param}"
}

# 下划线转驼峰
function toCamelCase(){
  local param=$1 #传入的字符串
  _action(){
    # 第一个单词
    local firstWord=$(echo "${param}"|awk -F '_' '{ print $1 }')
    # 去除首单词后的部分,放到一个数组中
    local remainWordList=($(echo "${param}"|awk -F '_' '{ for (i = 2; i <= NF; i++) print $i }'))
    local remainWord
    for item in "${remainWordList[@]}";do
        remainWord+=$(echo ${item}|string_firstLetter_toUpperCase)
    done
    echo "${firstWord}${remainWord}"
  }
  pip "${param}"
}
readonly -f length trim toUpperCase toLowerCase toCamelCase
