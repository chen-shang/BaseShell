#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
#===============================================================
import=$(basename ${BASH_SOURCE} .sh)
if [[ $(eval echo '$'${import}) == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Date/BaseTimeUnit.sh
#===============================================================
# 格式 2018-03-09
# 当前日期 [String]<-()
function localdate_now(){
  date "${DEFAULT_LOCALDATE_FORMAT}"
}
# 格式 2018
# 当前日期 [String]<-()
function localdate_now_year(){
  date +%Y
}
# 格式 03
# 当前日期 [String]<-()
function localdate_now_month(){
  date +%m
}
# 格式 09
# 当前日期 [String]<-()
function localdate_now_day(){
  date +%d
}
# 格式 Saturday
# 当前日期 [String]<-()
function localdate_now_week(){
  date +%A
}
# 格式 Saturday
# 当前日期 [String]<-()
function localdate_dayOfYear(){
  gdate -d "$1" +%j
}

# 取出给的日期的年份
function localdate_yearOf(){
  gdate -d "$1" +%Y
}
# 取出给的日期的月份
function localdate_monthOf(){
  gdate -d "$1" +%m
}
# 取出给的日期的日期
function localdate_dayOf(){
  gdate -d "$1" +%d
}

# 返回 ${duration} ${timeUnit}后的时间
function localdate_plus(){
  _NotNull "$1" &&  _NotNull "$2" && _NotNull "$3"
  local myLocaldate=$1 ; local duration=$2 ; local timeUnit=$3
  gdate -d "${myLocaldate} ${duration} ${timeUnit}" "${DEFAULT_LOCALDATE_FORMAT}"
}
