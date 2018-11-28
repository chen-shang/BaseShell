#!/usr/bin/env bash

# shellcheck disable=SC1091,SC2155
# 执行函数 [Any]<-(functionName:String,functionParameters:List<Any>)
execute(){
  functionName=$1
  shift # 参数列表以空格为分割左移一位,相当于丢弃掉第一个参数
  functionParameters=$*
  (${functionName} "${functionParameters}")
}

case $1 in
# -h 是 --help 的缩写,执行 manual
  "-h" | "--help" | "?") (manual) ;;
# 默认执行当前脚本中的main方法
  "") (main) ;;
# 执行当前脚本指定函数
  *) (execute "$@") ;;
esac