#!/usr/bin/env bash

# shellcheck disable=SC1091
#################引入需要测试的脚本################
source ./../../BaseShell/Lang/BaseString.sh
###################下面写单元测试#################

test-string_isBlank(){
  local result=$(string_isBlank "")
  assertEquals "${result}" "${TRUE}"
}

test-string_isNumeric(){
  local result=$(string_isNatural 123)
  assertEquals "${result}" "${TRUE}"
}


test-string_isNumeric2(){
  local result=$(string_isNatural 12aa3)
  assertEquals ${result} ${FALSE}
}
test-string_length(){
  local result=$(string_length 123)
  assertEquals ${result} 3
}
test-string_isEmpty(){
  local result=$(string_isEmpty "")
  assertEquals ${result} ${TRUE}
}
test-string_isNotBlank(){
  local result=$(string_isNotBlank "1")
  assertEquals ${result} ${TRUE}
}
#test-string_contains(){ #ignore
#
#}
#test-string_equals(){#ignore
#
#}
#test-string_toUpperCase(){#ignore
#
#}
#test-string_join(){#ignore
#
#}
#test-string_notEquals(){#ignore
#
#}
#test-string_toLowerCase(){#ignore
#
#}
#test-string_trim(){#ignore
#
#}

###################上面写单元测试#################
source ./../../BaseShell/Utils/BaseTestUtil.sh