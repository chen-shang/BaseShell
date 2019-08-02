#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
if [[ "${BASE_HEADER_IMPORTED}" == 0 ]]; then
  return
fi
readonly BASE_HEADER_IMPORTED=0
#===============================================================

# Header 的引入是为了引进每个脚本都公共的函数、常量等
source ./../../BaseShell/Lang/BaseObject.sh
source ./../../BaseShell/Log/BaseLog.sh
source ./../../BaseShell/Annotation/BaseAnnotation.sh

# 脚本使用帮助文档
manual(){ cat <"$0"                      \
         | grep -B1 'function'           \
         | grep -v "\\--"                \
         | sed "s/function //g"          \
         | sed "s/(){//g"                \
         | sed "s/#//g"                  \
         | sed 'N;s/\n/ /'               \
         | awk '{print $1,$3,$2}'        \
         | column -t
}

# 显示 Banner 图
if [[ -f ./../config.sh ]];then
  source ./../config.sh
fi
if [[ ${SHOW_BANNER} -ne ${FALSE} ]];then
  cat ./../../BaseShell/Utils/Banner |lolcat
fi
