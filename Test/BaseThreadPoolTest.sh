#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Concurrent/BaseThreadPool.sh
#===============================================================

test-new_threadPool(){
    new_threadPool 10
    local pool=$?

    for i in {1..10};do
      threadPool_run "${pool}" "log_info 1:${i}"
    done


  new_threadPool 5
  local pool2=$?

  for i in {1..10};do
    threadPool_run "${pool2}" "log_info 2:${i}"
  done
  wait

  wait
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
