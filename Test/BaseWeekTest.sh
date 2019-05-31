#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseTestHeader.sh
#################引入需要测试的脚本################
source ./../../BaseShell/Date/BaseWeek.sh
###################下面写单元测试#################
test-week_CH_now(){
  log_info "week_CH_now=$(week_CH_now)"
}
test-week_EN_now(){
  log_info "week_EN_now=$(week_EN_now)"
}
#===============================================================================
source ./../../BaseShell/Utils/BaseTestEnd.sh
    