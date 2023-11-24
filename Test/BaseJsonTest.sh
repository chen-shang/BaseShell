#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Json/BaseJson.sh
#===============================================================

test-json_empty() {
  local json=$(json_empty)
  assertEquals "${json}" "{}"
}

test-json_new() {
  local user1=$(json_new "id=1&name=chenshang")
  echo "${user1}" | json_toString
  local user2=$(json_new "id=2&name=chenshang22")
  echo "${user2}" | json_toPrettyString
  local json=$(json_new "user=[${user1},${user2}]")
  echo "${json}" | jq .
}

test-json_toCvs() {
  json='[{"name":"Alice","age":25,"location":"City A"},{"name":"Bob","age":30,"location":"City B"}]'
  local result=$(echo "${json}" | json_toCvs)
  local line0=$(echo "${result}" | awk 'NR==1')
  local line1=$(echo "${result}" | awk 'NR==2')
  local line2=$(echo "${result}" | awk 'NR==3')
  assertEquals "name,age,location" "${line0}"
  assertEquals "Alice,25,City A" "${line1}"
  assertEquals "Bob,30,City B" "${line2}"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
