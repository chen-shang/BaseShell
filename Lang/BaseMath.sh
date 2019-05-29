#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
if [[ "${BASE_MATH_IMPORTED}" == 0 ]]; then
  return
fi
readonly BASE_MATH_IMPORTED=0
#===============================================================
source ./../../BaseShell/Utils/BaseHeader.sh
source ./../../BaseShell/Lang/BaseString.sh

# D开头的数字代表十进制、B代表二进制、H代表十六进制、O代表八进制
function math_abs(){
  local param=$1
  _action(){
    local param=$1
    local firstLetter=$(string_indexOf "${param}" 0)
    case ${firstLetter} in
      +)digit=$(string_subString "${param}" 1);;
      -)digit=$(string_subString "${param}" 1);;
      *)digit=${param};;
    esac
    echo "${digit}"
  }
  pip "${param}"
}

# 转十进制
function math_toDeci(){
  local param=$1
  _action(){
    local param=$1
    local firstLetter=$(string_indexOf "${param}" 0)
    local sign obase digit
    # 先判断正负
    case ${firstLetter} in
      +)
        obase=$(string_indexOf "${param}" 1)
        digit=$(string_subString "${param}" 2)
      ;;
      -)
        sign="-"
        obase=$(string_indexOf "${param}" 1)
        digit=$(string_subString "${param}" 2)
      ;;
      *)
        obase=$(string_indexOf "${param}" 0)
        digit=$(string_subString "${param}" 1)
    esac
    case ${obase} in
      [0-9])
        echo "${param}"
      ;;
      D)
        echo "${sign}${digit}"
      ;;
      B) #二进制
        echo "${sign}$((2#${digit}))"
      ;;
      H) #十六进制
        echo "${sign}$((16#${digit}))"
      ;;
      O) #八进制
        echo "${sign}$((8#${digit}))"
      ;;
      *)
        log_error "illegal parameter ${param}"
      ;;
    esac
  }
  pip "${param}"
}

# 十进制转二进制
function math_toBinary(){
  local param=$1
  _action(){
    local deci=$(math_toDeci "$*")
    echo "obase=2;${deci}"|bc
  }
  pip "${param}"
}

# 十进制转十六进制
function math_toHex(){
  local param=$1
  _action(){
    local deci=$(math_toDeci "$*")
    echo "obase=16;${deci}"|bc
  }
  pip "${param}"
}

# 求两个数中较大值 [Double]<-(Double value1,Double value2)
function math_max(){
  [[ $(echo "$1 >= $2" | bc) -gt ${TRUE} ]] && echo "$1" || echo "$2"
}

# 求两个数中较小值 [Double]<-(Double value1,Double value2)
function math_min(){
  [[ $(echo "$1 >= $2" | bc) -gt ${TRUE} ]] && echo "$2" || echo "$1"
}

# 求一个数的算数平方根 [Double]<-(Double value)
function math_sqrt(){
  local param=$1

  _action(){
      echo "scale=4;sqrt($1)" | bc
  }
  pip "${param}"
}

# 平均数
function math_avg(){
  local sum=0
  local num=0
  for item in "$@";do
    sum=$(echo "scale=4;${sum}+${item}"|bc)
    ((num+=1))
  done
  echo "scale=4;${sum}/${num}"|bc
}

# 对数
function math_log(){
  case $# in
    1)
      #参数校验
      [[ $1 -le 0 ]] \
      && log_error "illegal parameters" \
      || awk "BEGIN { result=log($1); print result }"
    ;;
    2)
      #参数校验
      [[ $1 -le 0 || $2 -le 0 ]] \
      && log_error "illegal parameters" \
      ||awk "BEGIN { result=log($2)/log($1); print result }"
    ;;
    3)
      log_error "illegal parameters"
    ;;
  esac
}