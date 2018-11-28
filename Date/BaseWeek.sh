#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155

source ./../../BashShell/Utils/BaseHeader.sh
# shellcheck disable=SC1091
######################################################################
function week_EN_now(){
  local week=$(date +%w) # month (01..12)
  echo "${WEEKDAYS_ENGLISH_ENUM[week-1]}"
}
function week_CH_now(){
  local week=$(date +%w) # month (01..12)
  echo "${WEEKDAYS_CHINESE_ENUM[week-1]}"
}