#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
#===============================================================
import="$(basename "${BASH_SOURCE[0]}" .sh)_$$"
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
#导入工具包
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