#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Concurrent/BaseLock.sh
source ./../../BaseShell/Concurrent/BaseThreadPool.sh
#===============================================================
test-new_lock(){ #ignore
  lock=$(new_fd)
  log_debug "lock_fd:${lock}"
  new_lock "${lock}"
  read -r -u "${lock}" result
  assertTrue "${result}"

  lock=$(new_fd)
  log_debug "lock_fd:${lock}"
  new_lock "${lock}"
  read -r -u "${lock}" result2
  assertTrue "${result2}"

  (
    lock=$(new_fd)
    log_debug "lock_fd:${lock}"
    new_lock "${lock}"
    read -r -u "${lock}" result
    assertTrue "${result}"

    local lock=6
    log_debug "lock_fd:${lock}"
    new_lock "${lock}"
    read -r -u "${lock}" result
    assertTrue "${result}"
  )

  lock=$(new_fd)
  log_debug "lock_fd:${lock}"
  new_lock "${lock}"
  read -r -u "${lock}" result
  assertTrue "${result}"
}

echo 1 > file
add(){
  read item < file
  ((item++))
  log_info "中间值:${item}"
  echo ${item} > file
}

test-lock_run(){
#  set -x
  fd=$(new_fd)
  new_lock ${fd}

  for ((x=0;x<5;x++));do
    {
     lock_run "${fd}" "add"
    } &
  done

  wait
  cat file
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
