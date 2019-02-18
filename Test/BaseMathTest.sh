#!/usr/bin/env bash
# shellcheck disable=SC1091
#################引入需要测试的脚本################
source ./../../BaseShell/Lang/BaseMath.sh
###################下面写单元测试#################
math_avg 1.5 1.5

###################上面写单元测试#################
source ./../../BaseShell/Utils/BaseTestUtil.sh