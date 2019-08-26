#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
source ./../../BaseShell/Utils/BaseUuid.sh
source ./../../BaseShell/Concurrent/BaseLock.sh
#===============================================================================
# 该线程池的实现方法与上面的 BaseThreadPool.sh实现不同。该类与Java的ThreadPoolExecutor.sh实现类似
# 可以说是 ThreadPoolExecutor.java 的简版实现。开发过程当中对Java中一些不得已的设计有了深刻的理解


# coreSize:核心线程数
# keepAliveTime:线程的存活时间
# 任务队列使用的是无限的任务队列
# eg: new_ThreadPoolExecutor && local pool=$?
# 新建线程池 [int]<-(coreSize:Integer,keepAliveTime:Long)
new_ThreadPoolExecutor(){ _NotBlank "$1" "core size can not be null" && _Natural "$1" && _Min "0" "$1"
  local coreSize=$1 #核心线程数
  local keepAliveTime=${2:-1} #线程的存活时间

  local lock=$(new_fd)
  new_lock "${lock}"

  local fd=$(new_fd)
  new_fifo "${fd}"

  for((i=0;i<coreSize;i++));do
    {
      while :;do
        trap 'echo you hit Ctrl-C/Ctrl-\, now exiting.....; exit' SIGINT SIGQUIT
        lock_tryLock "${lock}" #这个地方必须加锁,防止read并发读导致task错乱
        read -t "${keepAliveTime}" -r -u "${fd}" task
        lock_unLock "${lock}"
        isBlank "${task}" && exit
        eval "${task}"
      done
    } &
  done

  return "${fd}"
}

executor_run(){
  local fd=$1 ;shift ;local task=$*
  echo "${task}" >& "${fd}"
  log_debug "submit:${fd}->${task}"
}