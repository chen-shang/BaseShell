#!/usr/bin/env bash
# 该脚本是为了防止循环引用的
# 导入的脚本名称,把所有的/替换成_,把所有的.替换成_
IMPORT_SHELL_FLAG="${BASH_SOURCE[1]////_}" && IMPORT_SHELL_FLAG="${IMPORT_SHELL_FLAG//./_}" && IMPORT_SHELL_FLAG="${IMPORT_SHELL_FLAG//-/_}"
if [[ $(eval echo '$'"${IMPORT_SHELL_FLAG}") != 0 ]]; then 
  eval "${IMPORT_SHELL_FLAG}=0"
  return 1;
fi