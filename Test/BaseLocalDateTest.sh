#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseTestHeader.sh
#################引入需要测试的脚本################
source ./../../BaseShell/Date/BaseLocalDate.sh
###################下面写单元测试#################
test-localdate(){
  log_info "localdate_now=$(localdate_now)"
  log_info "localdate_now_year=$(localdate_now_year)"
  log_info "localdate_now_month=$(localdate_now_month)"
  log_info "localdate_now_day=$(localdate_now_day)"
  log_info "localdate_now_week=$(localdate_now_week)"
  log_info "localdate_dayOfYear=$(localdate_dayOfYear)"
  log_info "localdate_yearOf=$(localdate_yearOf "2020/1/24T4:57")"
  log_info "localdate_monthOf=$(localdate_monthOf "2020-1-24")"
  log_info "localdate_dayOf=$(localdate_dayOf "2020-1-24")"
}
test-localdate_plus(){

  localdate_plus ${localdate_now} "1" ${TimeUnit_HOUR}
}

#===============================================================================
source ./../../BaseShell/Utils/BaseTestEnd.sh
    