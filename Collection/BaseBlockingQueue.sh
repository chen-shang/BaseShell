#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseHeader.sh
source ./../../BaseShell/Utils/BaseUuid.sh
#===============================================================
#todo update
if [[ ${BASE_BLOCKING_QUEUE_IMPORTED} != 0 ]]; then
  LOCK_POOL_MAP=()
  SIZE_MAP=()
fi
readonly BASE_BLOCKING_QUEUE_IMPORTED=0

# 初始化队列
function new_queue(){
  _NotNull $1 && _Numeric $1 && _Min "0" "$1"
  local size=$1

  available_fd
  local QUEUE=$? #在同一进程中,使用 4..250 之间的文件描述符关联有名管道, #下次new_threadPool,文件描述符+1
  local QUEUE_NAME="$(uuid_randomUUID)"
  [[ -e "${QUEUE_NAME}" ]] || mkfifo "${QUEUE_NAME}"
  eval "exec ${QUEUE}<>${QUEUE_NAME} && rm -rf ${QUEUE_NAME}"

  available_fd
  local LOCK_POOL=$? #
  local LOCK_POOL_NAME="$(uuid_randomUUID)"
  [[ -e "${LOCK_POOL_NAME}" ]] || mkfifo "${LOCK_POOL_NAME}"
  eval "exec ${LOCK_POOL}<>${LOCK_POOL_NAME} && rm -rf ${LOCK_POOL_NAME}"
  for ((i=0;i<size;i++));do echo "${i}" >& "${LOCK_POOL}";done

  LOCK_POOL_MAP[QUEUE]=${LOCK_POOL}
  SIZE_MAP[QUEUE]=${size}
  return ${QUEUE}
}

# 获取队列大小
function queue_size(){
  local queueName=$1
  echo ${SIZE_MAP[queueName]}
}

#获取锁
private_queue_getLock(){
  local queueName=$1
  local lockPool=${LOCK_POOL_MAP[queueName]}
  read -t 5 -r -u "${lockPool}" lock #能获取到锁,则可以入队,获取不到锁说明队列已满,并没有消费,阻塞在入队上
  echo ${lock}
}
#归还锁
private_queue_returnLock(){
  local queueName=$1
  local lockPool=${LOCK_POOL_MAP[queueName]}
  local lock=$2
  echo  ${lock} >& ${lockPool}
}

# 添加元素进队列
function queue_add(){
  local queueName=$1;local item=$2
  local queueName=$1;local action=$2
  local result=${FALSE}
  #获取锁
  local lock=$(private_queue_getLock "${queueName}")
  if [[ ! -z ${lock} ]];then
    #获取锁后的操作,入队
    echo ${item} >& ${queueName}
    result=${TRUE}
  fi
  echo ${result}
}

# 取出队首元素,队列为空返回空
function queue_pool(){
  local queueName=$1
  read -t 1 -r -u "${queueName}" item #能获取到锁,则可以入队,获取不到锁说明队列已满,并没有消费,阻塞在入队上
  echo ${item}
  unset item
  #释放锁
  private_queue_returnLock "${queueName}" "${lock}"
}

# 取出队首元素,队列为空阻塞
function queue_take(){
  local queueName=$1
  read -r -u "${queueName}" item #能获取到锁,则可以入队,获取不到锁说明队列已满,并没有消费,阻塞在入队上
  echo ${item}
  unset item
  #释放锁
  private_queue_returnLock "${queueName}" "${lock}"
}

# 清空队列
function queue_clear(){
  local queueName=$1
  cat <& ${queueName} > /dev/null
  local lockPool=${LOCK_POOL_MAP[queueName]}
  for ((i=0;i<size;i++));do echo "${i}" >& "${lockPool}";done
}

