#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Lang/BaseMath.sh
#===============================================================
# 测试 abs 求绝对值
test-math_abs(){
  local result=$(echo "-1"|math_abs)
  assertEquals "${result}" "1"

  # 用管道的形式传参
  local result=$(echo "1"|math_abs)
  assertEquals "${result}" "1"

  # 用直接传参的形式
  local result=$(math_abs "1.1")
  assertEquals "${result}" "1.1"

  local result=$(math_abs "-1.1")
  assertEquals "${result}" "1.1"
}

# 测试求平均数
test-math_avg(){
  local result=$(math_avg 1 2 3)
  assertEquals "${result}" "2.0000"
}

test-math_max(){
 local max=$(math_max 1 2)
 assertEquals "${max}" "2"

 local max=$(math_max 1.3 2.9)
 assertEquals "${max}" "2.9"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh