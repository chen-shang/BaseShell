#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
# BANNER图的位置
BANNER_PATH="./../../BaseShell/Banner"
# 是否显示BANNER
SHOW_BANNER=0

# 日志记录位置
LOG_DIR="${HOME}/.baseshell"
# 日志级别
LOG_LEVEL=SYSTEM
