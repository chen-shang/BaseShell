#!/usr/bin/env bash
# shellcheck disable=SC1091
# Header 的引入是为了引进每个脚本都公共的函数、常量等
#===============================================================
import="$(basename "${BASH_SOURCE[0]}" .sh)_$$"
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/config.sh
source ./../../BaseShell/Starter/BaseStarter.sh
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

# 加载自定义配置
if [[ -f ./../config.sh ]];then
  source ./../config.sh
fi

# 显示 Banner 图
if [[ ${SHOW_BANNER} == 0 ]];then
  cat < "${BANNER_PATH}" |lolcat
fi
