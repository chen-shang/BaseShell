#!/usr/bin/env bash
# shellcheck disable=SC1091
source ./../../BaseShell/Utils/BaseHeader.sh
source ./../../BaseShell/Concurrent/BaseThreadPool.sh
#===============================================================

function cache_set() {
  ^NotNull "$1" "key can not be null" && ^NotNull "$2" "value can not be null"
  local result
  result=$(redis-cli -c set "$1" "$2")
  if [[ "${result}" -eq "OK" ]];then
    echo "${TRUE}"
  else
    echo "${FALSE}"
  fi
}

function cache_get() {
  ^NotNull "$1" "key can not be null"
  redis-cli -c get "$1"
}