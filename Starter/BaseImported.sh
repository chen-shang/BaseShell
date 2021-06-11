#!/usr/bin/env bash
IMPORT_SHELL_FLAG="${BASH_SOURCE[1]////_}"   #导入的脚本名称,把所有的/替换成_
IMPORT_SHELL_FLAG="${IMPORT_SHELL_FLAG//./_}" #导入的脚本名称,把所有的.替换成_
if [[ $(eval echo '$'"${IMPORT_SHELL_FLAG}") == 0 ]]; then 
#  echo "${IMPORT_SHELL_FLAG} has been imported"
  return 0; 
else 
#  echo "${IMPORT_SHELL_FLAG} first imported"
  eval "${IMPORT_SHELL_FLAG}=0"; return 1; 
fi
