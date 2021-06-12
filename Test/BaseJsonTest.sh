#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Json/BaseJson.sh
#===============================================================

test-json_empty(){
  local json=$(json_empty)
  assertEquals "${json}" "{}"
}

test-json_new(){
  local user1=$(json_new "id=1&name=chenshang")
  echo "${user1}"|json_toString
  local user2=$(json_new "id=2&name=chenshang22")
  echo "${user2}"|json_toPrettyString
  local json=$(json_new "user=[${user1},${user2}]")
  echo "${json}"|jq .
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh