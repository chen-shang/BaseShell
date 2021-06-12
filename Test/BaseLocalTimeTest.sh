#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Date/BaseLocalTime.sh
#===============================================================
test-localtime(){
  localtime_now
  localtime_now_hour
  localtime_now_minutes
  localtime_now_seconds

  localtime_now_plusHour 1
  localtime_now_plushMinutes 2
  localtime_now_plusSeconds 3

  localtime_plus "19:56:00" "1${TimeUnit_MINUTE}"

  timestamp_now
  timestamp_toLocaldate 1568938550
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh