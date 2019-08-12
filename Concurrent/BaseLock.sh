#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename ${BASH_SOURCE} .sh)
if [[ $(eval echo '$'${import}) == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Utils/BaseStarter.sh
source ./../../BaseShell/Utils/BaseUuid.sh
#===============================================================

function new_lock(){
  enum_available_fd #在同一进程中,使用 4..250 之间的文件描述符关联有名管道, #下次new_threadPool,文件描述符+1
  local FD=$?
  local lockName="$(uuid_randomUUID)" #用当前的时间(秒)_当前进程ID最为有名管道名称,代表一个线程池
  [[ -e "${lockName}" ]] || mkfifo "${lockName}" #如果有名管道不存在,则创建一个有名管道当做线程池,利用有名管道作为阻塞队列来调度任务的执行
  eval "exec ${FD}<>${lockName} && rm -rf ${lockName}"
  for ((i=0;i<1;i++));do echo "${i}" >& "${FD}";done
  return "${FD}"
}

function lock_action(){
  local lock=$1 ; local action=$2
  private_lock_tryLock "${lock}"
  {
    eval "${action}"
  }
  private_lock_releaseLock "${lock}"
}

function new_flock() {
  local lock="$(uuid_randomUUID)" #用当前的时间(秒)_当前进程ID最为有名管道名称,代表一个线程池
  echo "${lock}"
}

function flock_action(){
  local lock=$1 ; local action=$2
  {
    flock -n 1024 || log_fail "lock error"
    ${action}
    rm -rf "/tmp/${lock}"
  } 1024<> "/tmp/${lock}"
}

private_lock_tryLock(){
  local lock=$1
  #能获取到锁,则可以入队,获取不到锁说明队列已满,并没有消费,阻塞在入队上
  read -r -u "${lock}"
}

private_lock_releaseLock(){
  local lockPool=$1
  echo  1 >& "${lockPool}"
}
