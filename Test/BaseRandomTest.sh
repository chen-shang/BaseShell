#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#################引入需要测试的脚本################
source ./../../BaseShell/Utils/BaseRandom.sh
###################下面写单元测试#################
for i in {1..10};do
  random_next 10
  sleep 1
done
###################上面写单元测试#################
source ./../../BaseShell/Utils/BaseTestUtil.sh
