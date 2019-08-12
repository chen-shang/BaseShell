#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename ${BASH_SOURCE} .sh)
if [[ $(eval echo '$'${import}) == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================

# 定时执行
scheduler_timer(){
  local time=$1 ; local action=$2
  while :;do
    # 调用后台任务执行,容易在父进程退出的时候漏掉还有后台进程正在执行,导致一直占用资源
    log_debug "${LINENO} [${FUNCNAME[*]}] ${action} ${time}"
    eval "${action}"
    sleep "${time}"
  done
}

# 定次执行
scheduler_counter(){
  local count=$1 ; local action=$2
  for (( i = 0; i < count; ++i )); do
     eval "${action}"
  done
}
