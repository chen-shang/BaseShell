#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Lang/BaseString.sh
#===============================================================
test-trim(){
  local str=" 1 2       3    "
  assertEquals "${str}" " 1 2       3    "

  local trim=$(trim "${str}")
  assertEquals "${trim}" "1 2       3"

  trim=$(echo "  123 "|trim)
  assertEquals "${trim}" "123"
}

test-string_subString(){
  result=$(string_subString "0 1234 567" "1" "1")
  assertEquals "${result}" " "
}

#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
