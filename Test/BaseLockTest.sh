#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Concurrent/BaseLock.sh
#===============================================================
test-new_lock(){
  new_lock
  local lock=$?
  echo ${lock}

  new_lock "1024"
  local lock=$?
  echo ${lock}
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
