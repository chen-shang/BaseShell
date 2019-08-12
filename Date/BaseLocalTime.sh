#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
#===============================================================
import=$(basename ${BASH_SOURCE} .sh)
if [[ $(eval echo '$'${import}) == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================

source ./../../BaseShell/Lang/BaseObject.sh
source ./../../BaseShell/Date/BaseTimeUnit.sh
#===============================================================
# 格式 00:53:26
# 当前时间 [String]<-()
function localtime_now(){
  gdate +%H:%M:%S
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

# 取出给定时间的
function localdate_Of(){
  gdate -d "$1" "${LOCALTIME_FORMAT}"
}
# 取出给定时间的小时
function localdate_hourOf(){
  gdate -d "$1" +%H
}
# 取出给的日期的分钟
function localdate_minutesOf(){
  gdate -d "$1" +%M
}
# 取出给的日期的秒
function localdate_secondsOf(){
  gdate -d "$1" +%S
}
# 格式 00
# 当前时间 [String]<-()
function localtime_plus(){
  _NotNull "$1" &&  _NotNull "$2" && _NotNull "$3"
  local myLocaldate=$1 ; local duration=$2 ; local timeUnit=$3
  gdate -d "${myLocaldate} ${duration} ${timeUnit}" "${LOCALTIME_FORMAT}"
}
