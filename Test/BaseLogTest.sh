#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseTestHeader.sh
#################引入需要测试的脚本################
source ./../../BaseShell/Log/BaseLog.sh
###################下面写单元测试#################
test-log(){
  log_debug   "1"
  log_info    "1"
  log_error   "1"
  log_trace   "1"
  log_warn    "1"
  log_success "1"
  log_info "    1\n2 "
  echo -e "1\n2"|trim #
  log_fail    "1"
}

#===============================================================================
source ./../../BaseShell/Utils/BaseTestEnd.sh
    