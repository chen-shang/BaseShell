#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Collection/BaseMap.sh
#===============================================================
test-map(){
  map_put "one" "1"
  assertTrue $?
  map_put "two" "2"
  assertTrue $?
  map_put "three" "3"
  assertTrue $?
  map_put "four" "4"
  assertTrue $?

  local result=$(map_get "one")
  assertEquals "${result}" "1"
  map_containsKey "one"
  assertTrue $?
  map_containsKey "five"
  assertFalse $?
  local size=$(map_size)
  assertEquals "${size}" "4"
  map_remove "one"
  assertTrue $?
  map_containsKey "one"
  assertFalse $?

  map_containsValue 1
  assertFalse $?
  map_containsValue 2
  assertTrue $?
  map_forEach log

  map_kv
}

mapper(){
  k=$1
  v=$2
  echo ${v}-$(uuidgen)
}

log(){
  k=$1
  v=$2
  log_debug "[${LINENO}]: ${k}=${v}"
}

test-new_map(){
  new_map qq
  declare -A qq=()
  qq_put "one" "1"
  qq_put "two" "2"
  qq_put "three" "3"

  new_map user
  declare -A user=(['chenshang']='{"age":2,"name":"frank"}')
  user_get "chenshang"|jq .name
}

test-map_mapper(){
  map_put "one" "1"
  map_put "two" "2"
  map_mapper mapper
  map_clear
  map_mapper mapper

  new_map qq
  declare -A qq=()
  qq_put "one" "1"
  qq_put "two" "2"
  qq_put "three" "3"
  qq_mapper mapper


}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
