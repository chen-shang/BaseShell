#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#################引入需要测试的脚本################
source ./../../BaseShell/Concurrent/BaseThreadPool.sh
###################下面写单元测试#################

function runnable(){
  sleep 5
  echo "$(gdate +%s.%N):I am running"
}

function consumer(){
  sleep 5

  echo "$(gdate +%s.%N):$*"
}

function supplier(){
  sleep 5

  local name=$1
  echo "$1"
}
test-threadPool_submit(){
  new_threadPool 512
  local pool=$?
  # 没有输入参数和输出参数的
  for i in {1..5000};do
    threadPool_submit "${pool}" "runnable"
  done

#  new_threadPool 300
#  local pool=$?
#  for i in {1..1000};do
#    threadPool_submit "${pool}" "runnable"
#  done
  wait
  say "运行完毕"

#  new_threadPool 10
#  local pool2=$?
#  (
#    for i in {1..100};do
#      # 有输入参数，但是没有返回值的
#      local param="线程池${pool2}:任务${i}"
#      threadPool_submit "${pool2}" "consumer ${param}"
#    done
#    wait
#    say "运行完毕"
#  ) &
#  (new_threadPool 100
#  local pool2=$?
#  for i in {1..100};do
#    # 可以接受返回值的
#    (
#      local name="${i}"
#      local age=$(threadPool_submit "${pool2}" "supplier 线程${pool2}:${name}")
#      echo "name:${name}->age:${age}"
#    ) &
#  done)
  wait
  log_info "done"
}

###################上面写单元测试#################
source ./../../BaseShell/Utils/BaseTestUtil.sh