#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseTestHeader.sh
#################引入需要测试的脚本################
source ./../../BaseShell/Lang/BaseMath.sh
###################下面写单元测试#################
test-math_abs(){ #ignore
  local result=$(math_abs "-1")
  assertEquals "${result}" "1"
  local result=$(echo "-1"|math_abs)
  assertEquals "${result}" "1"

  local result=$(math_abs "1")
  assertEquals "${result}" "1"
  local result=$(echo "1"|math_abs)
  assertEquals "${result}" "1"

  local result=$(math_abs "1.2")
  assertEquals "${result}" "1.2"
  local result=$(echo "2.3"|math_abs)
  assertEquals "${result}" "2.3"

  local result=$(math_abs "-1.2")
  assertEquals "${result}" "1.2"
  local result=$(echo "-2.3"|math_abs)
  assertEquals "${result}" "2.3"
}
test-math_toDeci(){ #ignore
  local result=$(math_toDeci B10)
  assertEquals "${result}" "2"
  local result=$(math_toDeci -B10)
  assertEquals "${result}" "-2"

  local result=$(math_toDeci 10)
  assertEquals "${result}" "10"
  local result=$(math_toDeci -10)
  assertEquals "${result}" "-10"

  local result=$(math_toDeci D10)
  assertEquals "${result}" "10"
  local result=$(math_toDeci -D10)
  assertEquals "${result}" "-10"

  local result=$(math_toDeci HF)
  assertEquals "${result}" "15"
  local result=$(math_toDeci -HF)
  assertEquals "${result}" "-15"

  local result=$(math_toDeci O7)
  assertEquals "${result}" "7"
  local result=$(math_toDeci -O10)
  assertEquals "${result}" "-8"
}
test-math_toBinary(){ #ignore
  local result=$(math_toBinary B10)
  assertEquals "${result}" "10"
  local result=$(math_toBinary -B10)
  assertEquals "${result}" "-10"
  local result=$(math_toBinary 2)
  assertEquals "${result}" "10"
  local result=$(math_toBinary -2)
  assertEquals "${result}" "-10"
}
test-math_toHex(){ #ignore
:
}
test-math_max(){ #ignore
  local result=$(math_max "1" "3")
  assertEquals "${result}" "3"

  local result=$(math_max "1.5" "1.51")
  assertEquals "${result}" "1.51"
}
test-math_min(){ #ignore
  local result=$(math_min "1" "3")
  assertEquals "${result}" "1"

  local result=$(math_min "1.5" "1.51")
  assertEquals "${result}" "1.5"
}
test-math_sqrt(){ #ignore
  local result=$(math_sqrt "25")
  assertEquals "${result}" "5.0000"

  local result=$(echo "25"|math_sqrt)
  assertEquals "${result}" "5.0000"
}
test-math_avg(){ #ignore
  local result=$(math_avg "1 2" "3" "4" "3" "40")
  assertEquals "${result}" "8.8333"
}
test-math_log(){
  local result=$(math_log 2 9)
  assertEquals "${result}" "3.16993"

  local result=$(math_log 10 -10)
  assertEquals "${result}" "1"
}

#===============================================================================
source ./../../BaseShell/Utils/BaseTestEnd.sh
    