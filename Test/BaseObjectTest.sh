#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseTestHeader.sh
#################引入需要测试的脚本################
source ./../../BaseShell/Lang/BaseObject.sh
###################下面写单元测试#################
test-equals(){
  local result=$(equals "1" "1" && echo 0 || echo 1)
  assertTrue "${result}"
  local result=$(equals "1" "2" && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(equals "1" "" && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(equals "" "" && echo 0 || echo 1)
  assertTrue "${result}"
  local result=$(equals " " "" && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(equals "1 " "1" && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(equals "1 " "1 " && echo 0 || echo 1)
  assertTrue "${result}"
}
test-delay(){
  local begin=$(localdatetime_now_timestamp)
  delay 1
  local end=$(localdatetime_now_timestamp)
  assertEquals "${end}" "$((begin+1))"

  local begin=$(localdatetime_now_timestamp)
  echo 1|delay
  local end=$(localdatetime_now_timestamp)
  assertEquals "${end}" "$((begin+1))"
}
test-isEmpty(){
  local result=$(isEmpty "1" && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(echo "1"|isEmpty && echo 0 || echo 1)
  assertFalse "${result}"

  local result=$(isEmpty " " && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(echo " "|isEmpty && echo 0 || echo 1)
  assertFalse "${result}"

  local result=$(isEmpty "" && echo 0 || echo 1)
  assertTrue "${result}"
  local result=$(echo ""|isEmpty && echo 0 || echo 1)
  assertTrue "${result}"

  local result=$(isEmpty 1 && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$( echo "1"|isEmpty && echo 0 || echo 1)
  assertFalse "${result}"
}
test-isNotEmpty(){
local result=$(isNotEmpty "1" && echo 0 || echo 1)
  assertTrue "${result}"
  local result=$(echo "1"|isNotEmpty && echo 0 || echo 1)
  assertTrue "${result}"

  local result=$(isNotEmpty " " && echo 0 || echo 1)
  assertTrue "${result}"
  local result=$(echo " "|isNotEmpty && echo 0 || echo 1)
  assertTrue "${result}"

  local result=$(isNotEmpty "" && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(echo ""|isNotEmpty && echo 0 || echo 1)
  assertFalse "${result}"

  local result=$(isNotEmpty 1 && echo 0 || echo 1)
  assertTrue "${result}"
  local result=$( echo "1"|isNotEmpty && echo 0 || echo 1)
  assertTrue "${result}"
}
test-isBlank(){
  local result=$(isBlank "1" && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(echo "1"|isBlank && echo 0 || echo 1)
  assertFalse "${result}"

  local result=$(isBlank " " && echo 0 || echo 1)
  assertTrue "${result}"
  local result=$(echo " "|isBlank && echo 0 || echo 1)
  assertTrue "${result}"

  local result=$(isBlank "" && echo 0 || echo 1)
  assertTrue "${result}"
  local result=$(echo ""|isBlank && echo 0 || echo 1)
  assertTrue "${result}"

  local result=$(isBlank "1" && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(echo "1"|isBlank && echo 0 || echo 1)
  assertFalse "${result}"
}
test-isNotBlank(){
  local result=$(isNotBlank "1" && echo 0 || echo 1)
  assertTrue "${result}"
  local result=$(echo "1"|isNotBlank && echo 0 || echo 1)
  assertTrue "${result}"

  local result=$(isNotBlank " " && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(echo " "|isNotBlank && echo 0 || echo 1)
  assertFalse "${result}"

  local result=$(isNotBlank "" && echo 0 || echo 1)
  assertFalse "${result}"
  local result=$(echo ""|isNotBlank && echo 0 || echo 1)
  assertFalse "${result}"

  local result=$(isNotBlank "1" && echo 0 || echo 1)
  assertTrue "${result}"
  local result=$(echo "1"|isNotBlank && echo 0 || echo 1)
  assertTrue "${result}"
}
test-hashCode(){
  local result=$(hashCode "A")
  assertEquals "${result}" "65"
  local result=$(echo "A"|hashCode)
  assertEquals "${result}" "65"
}
###################上面写单元测试#################
source ../Utils/BaseTestEnd.sh