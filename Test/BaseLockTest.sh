#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Concurrent/BaseLock.sh
#===============================================================
test-new_lock(){
  local lock
  lock=$(new_fd)
  log_debug "lock_fd:${lock}"
  new_lock "${lock}"
  read -r -u "${lock}" result
  assertTrue "${result}"

  local lock=$(new_fd)
  log_debug "lock_fd:${lock}"
  new_lock "${lock}"
  read -r -u "${lock}" result2
  assertTrue "${result2}"

  (
    local lock=$(new_fd)
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

  local lock=$(new_fd)
  log_debug "lock_fd:${lock}"
  new_lock "${lock}"
  read -r -u "${lock}" result
  assertTrue "${result}"
}

echo 1 > file
add(){
  read -r item < file
  ((item++))
  log_info "中间值:${item}"
  echo ${item} > file
}

test-lock_run(){
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
