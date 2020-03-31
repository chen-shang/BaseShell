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

# 脚本中被 #ignore 修饰的不自动生成文档
# 脚本使用帮助文档
manual(){ #ignore
  clear
  # 全部的函数以及描述
  equals "$1" "-a" && {
    cat <"$0"                       \
    | grep -v '#ignore'             \
    | grep -B1 '(){'                \
    | grep -v "\\--"                \
    | sed "s/function //g"          \
    | sed "s/(){//g"                \
    | sed 'N;s/\n/ /'               \
    | grep '#'                      \
    | sed "s/#//g"                  \
    | awk '{print $1,$3,$2}'        \
    | column -t
  }

  # 暴露的函数以及描述
  ! equals "$1" "-a" && {
    cat <"$0"                       \
    | grep -v '#ignore'             \
    | grep -B1 'function'           \
    | grep -v "\\--"                \
    | sed "s/function //g"          \
    | sed "s/(){//g"                \
    | sed "s/#//g"                  \
    | sed 'N;s/\n/ /'               \
    | awk '{print $1,$3,$2}'        \
    | column -t
  }
}

# 函数的详细描述
desc(){ _NotBlank "$1" "function can not be null" #ignore
  local func=$1
  local begin=$(cat <"$0"|grep -n -B10 "${func}(){"|grep -w "}"|tail -1|awk -F '-' '{print $1}')
  local end=$(cat <"$0"|grep -n "${func}(){"|tail -1|awk -F ':' '{print $1}')
  sed -n "$((begin+1)),${end}p" "$0"
}

# 加载自定义配置
if [[ -f ./../config.sh ]];then
  source ./../config.sh
fi

# 显示 Banner 图
if [[ ${SHOW_BANNER} == 0 ]];then
  cat < "${BANNER_PATH}" |lolcat
fi
