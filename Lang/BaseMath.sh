#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================
# D开头的数字代表十进制、B代表二进制、H代表十六进制、O代表八进制
# 绝对值 [Int]<-(param:Number)
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

# 不支持小数
# 转十进制 [Int]<-(param:Number)
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
# 不支持小数
# 转二进制 [Binary]<-(param:Number)
function math_toBinary(){
  local param=$1
  _action(){
    local param=$1
    local deci=$(math_toDeci "${param}")
    echo "obase=2;${deci}"|bc
  }
  pip "${param}"
}
# 不支持小数
# 十六进制 [Binary]<-(param:Number)
function math_toHex(){
  local param=$1
  _action(){
    local param=$1
    local deci=$(math_toDeci "${param}")
    echo "obase=16;${deci}"|bc
  }
  pip "${param}"
}

# 求两个数中较大值 [Double]<-(value1:Number,value2:Number)
function math_max(){
  [[ $(echo "$1 >= $2" | bc) -gt ${TRUE} ]] && echo "$1" || echo "$2"
}

# 求两个数中较小值 [Double]<-(value1:Number,value2:Number)
function math_min(){
  [[ $(echo "$1 >= $2" | bc) -gt ${TRUE} ]] && echo "$2" || echo "$1"
}

# 求一个数的算数平方根 [Double]<-(value1:Number)
function math_sqrt(){
  local param=$1

  _action(){
    local param=$1
    echo "scale=4;sqrt(${param})" | bc
  }
  pip "${param}"
}

# 平均数 [Double]<-(value1:Number...)
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
      _Min "0" "$1" "真数不能为负数"
      awk "BEGIN { result=log($1); print result }"
    ;;
    2)
      _Min "0" "$1" "底数不能为负数"
      _Min "0" "$2" "真数不能为负数"
      awk "BEGIN { result=log($2)/log($1); print result }"
    ;;
    *)
      log_error "illegal parameters"
    ;;
  esac
}
