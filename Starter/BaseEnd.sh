#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
#===============================================================
# 执行函数 [Any]<-(functionName,functionParameters:List<Any>)
execute(){
  local functionName=$1
  shift # 参数列表以空格为分割左移一位,相当于丢弃掉第一个参数
  local functionParameters=$*
  eval "${functionName} ${functionParameters}"
}

case $1 in
  "-ha"| "?a") manual '-a' ;;     # -h 是 --help 的缩写, a 是all 的缩写执行 manual
  "-h" | "?") manual ;;           # -h 是 --help 的缩写,执行 manual
  "") main ;;                     # 默认执行当前脚本中的main方法
  *) execute "$*" ;;              # 执行当前脚本指定函数
esac