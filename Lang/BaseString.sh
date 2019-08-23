#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Lang/BaseObject.sh

# 字符串长度 [Int]<-(param:String)
function string_length(){
  local param=$*
  _action(){
    local param=$*
    echo -e "${#param}"
  }
  pip "${param}"
}

# 去掉字符串前后空格 [String]<-(param:String)
function trim(){
  local param=$*
  _action(){
    local param=$*
    echo -e "${param}" | grep -o "[^ ]\+\( \+[^ ]\+\)*"
  }
  pip "${param}"
}

# 转大写
function toUpperCase(){
  local param=$*
  _action(){
    local param=$*
    echo -e "${param}" | tr '[:lower:]' '[:upper:]'
  }
  pip "${param}"
}

# 转小写
function toLowerCase(){
  local param=$*
  _action(){
    echo -e "${param}" | tr '[:upper:]' '[:lower:]'
  }
  pip "${param}"
}

# 判断两个字符串是否相等,忽略大小写
function string_equalsIgnoreCase(){
  equals "$(toUpperCase "$1")" "$(toUpperCase "$2")"
}

# 查看首字母
function string_startsWith(){
  local value1=$1
  local value2=$2
  [[ "${value1}" == "${value2}"* ]] && return "${TRUE}" || return "${FALSE}"
}

# 查看尾字母
function string_endsWith(){
  local value1=$1
  local value2=$2
  [[ "${value1}" == *"${value2}" ]] && return "${TRUE}" || return "${FALSE}"
}

# 字符串包含
function string_contains(){
  local value1=$1
  local value2=$2
  [[ ${value1} =~ ${value2} ]] && return "${TRUE}" || return "${FALSE}"
}

# 字符串下标所在位置的字符,从左向右
function string_indexOf(){
  local param=$1
  local index=$2
  echo -e "${param:${index}:1}"
}

# 字符串下标所在位置的字符,从右向左
function string_lastIndexOf(){
  local param=$1
  local index=$2
  echo -e "${param:0-${index}:1}"
}

# 字符串下标所在位置的字符,取子字符串
function string_subString(){
  local param=$1 #传入的字符串
  if [[ $# -eq 2 ]];then
    local begin=$2 #起始位置
    echo -e "${param:${begin}}"
  elif [[ $# -eq 3 ]];then
    local begin=$2 #起始位置
    local end=$3
    echo -e "${param:${begin}:$((end-begin + 1))}"
  fi
}
function string_firstLetter_toUpperCase(){
  local param=$1 #传入的字符串
  _action(){
    local param=$*
    echo -e "$(string_indexOf "${param}" "0"|trim "$@"|toUpperCase)$(string_subString "${param}" "1")"
  }
  pip "${param}"
}

# 下划线转驼峰
function toCamelCase(){
  local param=$1 #传入的字符串
  _action(){
    # 第一个单词
    local firstWord
    firstWord=$(echo "${param}"|awk -F '_' '{ print $1 }')
    # 去除首单词后的部分,放到一个数组中
    local remainWordList
    remainWordList=$(echo "${param}"|awk -F '_' '{ for (i = 2; i <= NF; i++) print $i }')
    for item in ${remainWordList};do
        remainWord+=$(echo "${item}"|string_firstLetter_toUpperCase "$@")
    done
    echo -e "${firstWord}${remainWord}"
  }
  pip "${param}"
}
#
#function string_charAt(){
#:
#}
#function string_compareTo(){
#:
#}
#function string_compareToIgnoreCase(){
#:
#}
#function string_concat(){
#:
#}
#function string_equals(){
#:
#}
#function string_format(){
#:
#}
#function string_isEmpty(){
#:
#}
#function string_join(){
#:
#}
#function string_replace(){
#:
#}
#function string_replaceAll(){
#:
#}

readonly -f string_length trim toUpperCase toLowerCase toCamelCase


