#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
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
