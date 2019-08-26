#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ../../BaseShell/Starter/BaseHeader.sh
source ./../../BaseShell/Utils/BaseUuid.sh
source ./../../BaseShell/Concurrent/BaseLock.sh

#导入工具包
#===============================================================================
new_threadPool(){ _NotBlank "$1" "core size can not be null"
  local coreSize=$1

  new_FIFO
  local threadPool=$?
  log_debug "threadPool FD:${threadPool}"

  new_lock
  local lock=$?

  for ((i=0;i<coreSize;i++));do
    {
      while :;do
        #从任务队列中取出任务
        lock_tryLock "${lock}"
        read -r -u"${threadPool}" task
        lock_unLock "${lock}"

        isNotBlank "${task}" && {
          #执行任务
          eval "${task[@]}"
        }
      done
    } &
  done

  return ${threadPool}
}

threadPool_run(){
  local pool=$1
  local task=$2
  echo "${task}" >& "${pool}"
}