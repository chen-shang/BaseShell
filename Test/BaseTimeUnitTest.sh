#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseTestHeader.sh
#################引入需要测试的脚本################
source ./../../BaseShell/Date/BaseTimeUnit.sh
###################下面写单元测试#################
test-TimeUnit.SECOND.sleep(){
  log_info $(localdatetime_now_second)
  TimeUnit.SECOND.sleep 2
  log_info $(localdatetime_now_second)
  TimeUnit.MINUTE.sleep 1
  log_info $(localdatetime_now_second)
}
#===============================================================================
source ./../../BaseShell/Utils/BaseTestEnd.sh
    