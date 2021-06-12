#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Concurrent/BaseThreadPool.sh
#===============================================================

test-new_threadPool(){
    new_threadPool 10
    local pool=$?

    log_debug "pool:${pool}"
    for i in {1..10};do
      threadPool_submit "${pool}" "sleep 1;log_info 1:${i}"
    done

    new_threadPool 10
    local pool2=$?

    log_debug "pool2:${pool2}"
    for x in {1..10};do
      threadPool_submit "${pool2}" "sleep 1;log_info 2:${x}"
    done

    wait
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
