#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/Date/BaseTimeUnit.sh
#===============================================================
function week_EN_now(){
  local week=$(date +%w) # month (01..12)
  echo "${WEEKDAYS_ENGLISH_ENUM[week-1]}"
}
function week_CH_now(){
  local week=$(date +%w) # month (01..12)
  echo "${WEEKDAYS_CHINESE_ENUM[week-1]}"
}

function week_isWeekend(){
  local week=$(gdate -d "$1" +%w)
  equals ${week} "6" || equals ${week} "7"
}