#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
#导入的脚本名称,把所有的/替换成_,把所有的.替换成_
IMPORT_SHELL_FLAG="${BASH_SOURCE[0]////_}" && IMPORT_SHELL_FLAG="${IMPORT_SHELL_FLAG//./_}"
if [[ $(eval echo '$'"${IMPORT_SHELL_FLAG}") == 0 ]]; then return; fi #已导入就直接返回
eval "${IMPORT_SHELL_FLAG}=0" 
#===============================================================
# BANNER图的位置
BANNER_PATH="./../../BaseShell/Banner"
# 是否显示BANNER
SHOW_BANNER=0

# 日志记录位置
LOG_DIR="${HOME}/.baseshell"
# 日志级别
LOG_LEVEL=SYSTEM
