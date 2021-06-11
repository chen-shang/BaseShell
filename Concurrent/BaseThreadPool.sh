#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================
# 该线程池的实现方法与下面的 BaseThreadPoolExecutor.sh 实现不同。与Java中的线程池实现不同
# 实现方式令牌队列中存放指定执行个数的令牌,令牌队列为空的时候阻塞任务的提交
# 令牌队列不为空的时候允许拿走一个令牌执行
# 该令牌队列保证了:在多线程环境下获取令牌是互斥的,利用fifo的阻塞和read命令一次读取一行

# coreSize:核心线程数
# eg: new_threadPool && local pool=$?
# 新建线程池 [int]<-(coreSize:Integer)
function new_threadPool(){ _NotBlank "$1" "core size can not be null" && _Natural "$1" && _Min "0" "$1"
  local coreSize=$1
  local fd=$(new_fd)
  new_fifo "${fd}"
  for((i=0;i<coreSize;i++));do
    #写入令牌
    eval "echo ${i} >& ${fd}"
  done
  return "${fd}"
}

# 注意这个方法是阻塞方法
# 提交一个任务 []<-(task:Function)
function threadPool_submit(){ _NotBlank "$1" "thread pool can not be null"
  local fd=$1 ;shift ;local task=$*
  #获取执行令牌,获取不到令牌则阻塞,直到有任务结束执行归还令牌
  read -r -u "${fd}" token
  {
    eval "${task}" #开始执行耗时操作
    eval "echo ${token} >& ${fd}" #归还令牌
  } &
}