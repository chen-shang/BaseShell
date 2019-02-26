#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseHeader.sh
source ./../../BaseShell/Utils/BaseUuidUtil.sh
#===============================================================

# new a thread pool
function new_threadPool(){
  ^NotNull "$1" && ^Numeric "$1" && ^Min "0" "$1"

  available_fd #在同一进程中,使用 4..250 之间的文件描述符关联有名管道, #下次new_threadPool,文件描述符+1
  local FD=$?

  local coreSize=$1
  local threadPoolName="$(uuid_randomUUID)" #用当前的时间(秒)_当前进程ID最为有名管道名称,代表一个线程池
  [[ -e "${threadPoolName}" ]] || mkfifo "${threadPoolName}" #如果有名管道不存在,则创建一个有名管道当做线程池,利用有名管道作为阻塞队列来调度任务的执行
  eval "exec ${FD}<>${threadPoolName} && rm -rf ${threadPoolName}"
  for ((i=0;i<coreSize;i++));do echo "${i}" >& "${FD}";done
  return "${FD}"
}

# submit a task
function threadPool_submit(){
  local threadPool=$1
  shift
  local action="$*"
  read -r -u "${threadPool}" item       #从线程池获取一个任务执行令牌，获取不到则挂起,禁止提交任务,说明已经达到任务并发阈值
  {
    eval "${action}"                      #执行任务动作
    echo "${item}" >& "${threadPool}"   #执行完成退还令牌给其他人用
  } &
}