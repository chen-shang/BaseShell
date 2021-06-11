#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================
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

# 转大写 [String]<-(param:String)
function toUpperCase(){
  local param=$*
  _action(){
    local param=$*
    echo -e "${param}" | tr '[:lower:]' '[:upper:]'
  }
  pip "${param}"
}

# 转小写 [String]<-(param:String)
function toLowerCase(){
  local param=$*
  _action(){
    echo -e "${param}" | tr '[:upper:]' '[:lower:]'
  }
  pip "${param}"
}

# 判断两个字符串是否相等,忽略大小写 [Boolean]<-(param1:String,param1:String)
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

# 字符串首字母转大写 [String]<-(param:String)
function string_firstLetter_toUpperCase(){
  local param=$1 #传入的字符串
  _action(){
    local param=$*
    echo -e "$(string_indexOf "${param}" "0"|trim|toUpperCase)$(string_subString "${param}" "1")"
  }
  pip "${param}"
}

# 下划线转驼峰 [String]<-(param:String)
function toCamelCase(){
  local param=$1 #传入的字符串
  _action(){
    # 第一个单词
    local firstWord
    firstWord=$(echo "${param}"|awk -F '_' '{ print $1 }')
    # 去除首单词后的部分,放到一个数组中
    local remainWordList
    remainWordList=$(echo "${param}"|awk -F '_' '{ for (i = 2; i <= NF; i++) print $i }')
    local item;for item in ${remainWordList};do
        remainWord+=$(echo "${item}"|string_firstLetter_toUpperCase "$@")
    done
    echo -e "${firstWord}${remainWord}"
  }
  pip "${param}"
}

# 转下划线
function toUnderlineCase(){
  local param=$1 #传入的字符串
  _action(){
    echo ${param}|sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g'
  }
  pip "${param}"
}

#
#function string_charAt(){ #ignore
#:
#}
#function string_compareTo(){ #ignore
#:
#}
#function string_compareToIgnoreCase(){ #ignore
#:
#}
#function string_concat(){ #ignore
#:
#}
#function string_equals(){ #ignore
#:
#}
#function string_format(){ #ignore
#:
#}
#function string_isEmpty(){ #ignore
#:
#}
#function string_join(){ #ignore
#:
#}

# 字符串替换
function string_replace(){
  local param=$1
  local source=$2
  local target=$3
  echo -e "${param/${source}/${target}}"
}

# 字符串替换
function string_replaceAll(){
  local param=$1
  local source=$2
  local target=$3
  echo -e "${param//${source}/${target}}"
}

# 字符串去掉尾部一个字符
function string_tailRemove(){
  local param=$*
  _action(){
    local param=$*
    echo "${param}"|sed s'/.$//'
  }
  pip "${param}"
}
