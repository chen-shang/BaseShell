#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155

source ./../../BashShell/Date/BaseTimeUnit.sh
LOCALDATE_FORMAT="+%Y-%m-%d"

function localdate(){
  local myLocaldate="${FUNCNAME[0]}"
  case $1 in
  getYear)
     localdate_yearOf "${myLocaldate}"
     ;;
  getMonth)
     localdate_monthOf "${myLocaldate}"
     ;;
  getDay)
     localdate_dayOf "${myLocaldate}"
     ;;
  getDayOfYear)
     localdate_dayOfYear "${myLocaldate}"
     ;;
  plus)
     localdate_plus "${myLocaldate}" "$1" "$2"
  esac
}

#将一个日期转换成类似对象
function localdate_of(){
  local myLocaldate=$1
  test -n "$(declare -f localdate)" || return
  eval "${_/localdate/${myLocaldate}}"
}
# 格式 2018-03-09
# 当前日期 [String]<-()
function localdate_now(){
  gdate "${LOCALDATE_FORMAT}"
}
# 格式 2018
# 当前日期 [String]<-()
function localdate_now_year(){
  gdate +%Y
}
# 格式 03
# 当前日期 [String]<-()
function localdate_now_month(){
  gdate +%m
}
# 格式 09
# 当前日期 [String]<-()
function localdate_now_day(){
  gdate +%d
}
# 格式 Saturday
# 当前日期 [String]<-()
function localdate_now_week(){
  gdate +%A
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
  ^NotNull "$1" &&  ^NotNull "$2" && ^NotNull "$3"
  local myLocaldate=$1 ; local duration=$2 ; local timeUnit=$3
  gdate -d "${myLocaldate} ${duration} ${timeUnit}" "${LOCALDATE_FORMAT}"
}
