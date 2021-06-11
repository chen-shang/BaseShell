#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/Date/BaseTimeUnit.sh
#===============================================================
function month_EN_now(){
  local month=$(date +%m) # month (01..12)
  echo "${MONTH_ENGLISH_ENUM[month-1]}"
}
function month_CH_now(){
  local month=$(date +%m) # month (01..12)
  echo "${MONTH_CHINESE_ENUM[month-1]}"
}
# 支持 数字、中文转英文
function month_EN_convert(){
  local month=-1
  case $1 in
    [1-"12"]): month="$1"-1 ;;
    *): month="$(list_indexOf "${MONTH_CHINESE_ENUM[*]}" "$1")" ;;
  esac
  echo "${MONTH_ENGLISH_ENUM[month]}"
}
# 支持 数字、英文转中文
function month_CH_convert(){
  local month=-1
  case "$1" in
    [1-"12"]): month="$1"-1 ;;
    *): month="$(list_indexOf "${MONTH_ENGLISH_ENUM[*]}" "$1")" ;;
  esac
  echo "${MONTH_CHINESE_ENUM[month]}"
}
