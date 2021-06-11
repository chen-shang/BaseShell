#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155,SC2154
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/Date/BaseTimeUnit.sh
source ./../../BaseShell/Date/BaseTimestamp.sh
#===============================================================
# 格式 00:53:26
# 当前时间 [String]<-()
function localtime_now(){
  gdate "${DEFAULT_LOCALTIME_FORMAT}"
}
# 格式 00
# 当前时间 [String]<-()
function localtime_now_hour(){
  gdate +%H
}
# 格式 00
# 当前时间 [String]<-()
function localtime_now_minutes(){
  gdate +%M
}
# 格式 00
# 当前时间 [String]<-()
function localtime_now_seconds(){
  gdate +%S
}

# 格式 00
# 当前时间 [String]<-()
function localtime_now_plusHour(){
  duration=$1
  gdate -d "$(localtime_now) ${duration}${TimeUnit_HOUR}" "${DEFAULT_LOCALTIME_FORMAT}"
}
# 格式 00
# 当前时间 [String]<-()
function localtime_now_plushMinutes(){
  duration=$1
  gdate -d "$(localtime_now) ${duration}${TimeUnit_MINUTE}" "${DEFAULT_LOCALTIME_FORMAT}"
}
# 格式 00
# 当前时间 [String]<-()
function localtime_now_plusSeconds(){
  duration=$1
  gdate -d "$(localtime_now) ${duration}${TimeUnit_SECOND}" "${DEFAULT_LOCALTIME_FORMAT}"
}

# 格式 00
# 当前时间 [String]<-()
function localtime_plusHour(){
  local localtime=$1 ;local duration=$2
  gdate -d "${localtime} ${duration}${TimeUnit_HOUR}" "${DEFAULT_LOCALTIME_FORMAT}"
}
# 格式 00
# 当前时间 [String]<-()
function localtime_plushMinutes(){
  local localtime=$1 ;local duration=$2
  gdate -d "${localtime} ${duration}${TimeUnit_MINUTE}" "${DEFAULT_LOCALTIME_FORMAT}"
}
# 格式 00
# 当前时间 [String]<-()
function localtime_plusSeconds(){
  local localtime=$1 ;local duration=$2
  gdate -d "${localtime}  ${duration}${TimeUnit_SECOND}" "${DEFAULT_LOCALTIME_FORMAT}"
}

function localtime_plus(){
  local localtime=$1 ;local duration=$2
  gdate -d "${localtime}  ${duration}" "${DEFAULT_LOCALTIME_FORMAT}"
}

function localtime_format(){
  gdate -d "$1" "$2"
}