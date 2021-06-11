#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
#===============================================================
# 默认引入的常用工具包
source ./../../BaseShell/Lang/BaseObject.sh
source ./../../BaseShell/Log/BaseLog.sh
source ./../../BaseShell/Annotation/BaseAnnotation.sh
source ./../../BaseShell/Lang/BaseString.sh
#===============================================================
# 默认引入的常用工具函数
# 脚本中被 #ignore 修饰的不自动生成文档
# 脚本使用帮助文档
function manual(){ #ignore
  cat <"$0"                  |
      grep -v '#ignore'      |
      grep -B1 'function'    |
      grep -EB1 '(){|() {}'  |
      grep -v "\\--"         |
      sed "s/function //g"   |
      sed "s/(){//g"         |
      sed "s/() {//g"        |
      sed 'N;s/\n/ /'        |
      grep '#'               |
      sed "s/#//g"           |
      awk '{print $1,$3,$2}' |
      column -t
}

# 函数的详细描述
function desc() {
  local func=$1
  local begin=$(cat <"$0" | grep -n -B10 "${func}(){" | grep -w "}" | tail -1 | awk -F '-' '{print $1}')
  local end=$(cat <"$0" | grep -n "${func}(){" | tail -1 | awk -F ':' '{print $1}')
  sed -n "$((begin + 1)),${end}p" "$0"
}

case $1 in
  "-ha" | "?a") manual ;; # -h 是 --help 的缩写, a 是all 的缩写执行 manual
  "-ds")  shift ; desc "$*"  ;; # -d 是 --description 的缩写
esac
