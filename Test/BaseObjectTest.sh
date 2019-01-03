#!/usr/bin/env bash

# shellcheck disable=SC1091
#################引入需要测试的脚本################
source ./../../BaseShell/Lang/BaseObject.sh
###################下面写单元测试#################

test-equals(){
  $(equals "1" "1")
  echo $?
  $(equals "1" "0") && echo 0 || echo 1
}
###################上面写单元测试#################
source ./../../BaseShell/Utils/BaseTestUtil.sh