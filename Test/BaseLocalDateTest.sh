#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Date/BaseLocalDate.sh
#===============================================================
test-localdate(){
  localdate_now
  localdate_now_year
  localdate_now_month
  localdate_now_day
  localdate_now_week
  localdate_now_dayOfYear

  localdate_getYear $(localdate_now)
  localdate_getMonth $(localdate_now)
  localdate_getDay $(localdate_now)
  localdate_getWeek $(localdate_now)
  localdate_getDayOfYear $(localdate_now)

  localdate_getYear 20190908
  localdate_getMonth 20190908
  localdate_getDay 20190908
  localdate_getWeek 20190908
  localdate_getDayOfYear 20190908

  localdate_now_plusYear 1
  localdate_now_plusMonth 2
  localdate_now_plusDay 3
  localdate_now_plusWeek 1


  localdate_now_plusYear -1
  localdate_now_plusMonth -2
  localdate_now_plusDay -3
  localdate_now_plusWeek -1

  localdate_plus '20190908' '1year'
  localdate_plus '20190908' '1month'
  localdate_plus '20190908' '1day'

  localdate_isEqual  "2019-09-09 09:00" "2019-09-09" && echo yes || echo no
  localdate_isBefore "2019-09-09 09:00" "2019-09-09 19:00" && echo yes || echo no
  localdate_isAfter  "2019-09-10" "2019-09-09" && echo yes || echo no

  localdate_getWeek 2019-09-10
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh