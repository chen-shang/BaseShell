#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155

if [[ ${BASE_HEADER_IMPORTED} != 0 ]]; then
  # 标识该Header已经source过,防止重复source执行多次
  readonly BASE_HEADER_IMPORTED=0

  # Header 的引入是为了引进每个脚本都公共的函数、常量等
  source ./../../BaseShell/Constant/BaseConstant.sh
  source ./../../BaseShell/Lang/BaseObject.sh
  source ./../../BaseShell/Log/BaseLog.sh
  source ./../../BaseShell/Annotation/BaseAnnotation.sh
  # 脚本使用帮助文档
  manual(){ cat <"$0" \
  | grep -B1 'function' \
  | grep -v "\\--" \
  | sed "s/function //g" \
  | sed "s/(){//g" \
  | sed "s/#//g" \
  | sed 'N;s/\n/:/' \
  | awk -F ':' '{print $2,$1,$3}' \
  | column -t
  }
fi