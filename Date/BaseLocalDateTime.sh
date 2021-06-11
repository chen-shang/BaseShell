#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/Date/BaseTimeUnit.sh
source ./../../BaseShell/Date/BaseLocalDate.sh
source ./../../BaseShell/Date/BaseLocalTime.sh
source ./../../BaseShell/Date/BaseTimestamp.sh
#===============================================================
# 格式 2018-03-09T00:53:26
# 当前日期:时间 [String]<-()
function localdatetime_now(){
  date "${DEFAULT_LOCALDATETIME_FORMAT}"
}

# 秒级别的时间戳
function localdatetime_now_timestamp(){
  date +%s
}

# 格式 2018-03-09T00:53:26
# 当前日期:时间 [String]<-()
function localdatetime_now_hour(){
  localtime_now_hour
}

# 格式 2018-03-09T00:53:26
# 当前日期:时间 [String]<-()
function localdatetime_now_minute(){
  localtime_now_minutes
}

# 格式 2018-03-09T00:53:26
# 当前日期:时间 [String]<-()
function localdatetime_now_second(){
  localtime_now_seconds
}

# 格式 2018
# 当前日期 [String]<-()
function localdatetime_now_year(){
  localdate_now_year
}
# 格式 03
# 当前日期 [String]<-()
function localdatetime_now_month(){
  localdate_now_month
}
# 格式 09
# 当前日期 [String]<-()
function localdatetime_now_day(){
  localdate_now_day
}
# 格式 Saturday
# 当前日期 [String]<-()
function localdatetime_now_week(){
  localdate_now_week
}
# 格式 251
# 今天是一年的第几天
function localdatetime_now_dayOfYear(){
  localdate_now_dayOfYear
}
# 格式 Saturday
# 当前日期 [String]<-()
function localdatetime_getDayOfYear(){ _NotBlank "$1"
  localdate_getDayOfYear "$1"
}
# 取出给的日期的年份
function localdatetime_getYear(){ _NotBlank "$1"
  localdate_getYear "$1"
}
# 取出给的日期的月份
function localdatetime_getMonth(){ _NotBlank "$1"
  localdate_getMonth "$1"
}
# 取出给的日期的日期
function localdatetime_getDay(){ _NotBlank "$1"
  localdate_getDay "$1"
}
# 格式 Saturday
# 取出给的日期是星期几
function localdatetime_getWeek(){ _NotBlank "$1"
  localdate_getWeek "$1"
}

# 格式 Saturday
# 取出给的日期是星期几
function localdatetime_getLocaldate(){ _NotBlank "$1"
  gdate -d "$1" "${DEFAULT_LOCALDATE_FORMAT}"
}

# 格式 Saturday
# 取出给的日期是星期几
function localdatetime_getLocaltime(){ _NotBlank "$1"
  gdate -d "$1" "${DEFAULT_LOCALTIME_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当前时间+x天后的日期 [String]<-(duration:Integer)
function localdatetime_now_plusDay(){ _NotBlank "$1" "duration[day] can not be null"
  local duration=$1
  gdate -d "$(localdatetime_now) ${duration} day" "${DEFAULT_LOCALDATETIME_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当前时间+x天后的日期 [String]<-(duration:Integer)
function localdatetime_now_plusWeek(){ _NotBlank "$1" "duration[week] can not be null"
  local duration=$1
  gdate -d "$(localdatetime_now) ${duration} week" "${DEFAULT_LOCALDATETIME_FORMAT}"
}
# 返回值格式 yyyyMMdd
# 当前时间+x月后的日期 [String]<-(duration:Integer)
function localdatetime_now_plusMonth(){ _NotBlank "$1" "duration[month] can not be null"
  local duration=$1
  gdate -d "$(localdatetime_now) ${duration} month" "${DEFAULT_LOCALDATETIME_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当前时间+x年后的日期 [String]<-(duration:Integer)
function localdatetime_now_plusYear(){ _NotBlank "$1" "duration[year] can not be null"
  local duration=$1
  gdate -d "$(localdatetime_now) ${duration} year" "${DEFAULT_LOCALDATETIME_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当指定时间+x天后的日期 [String]<-(duration:Integer)
function localdatetime_plusDay(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "duration[day] can not be null"
  local myLocaldate=$1 ; local duration=$2
  gdate -d "${myLocaldate} ${duration} day" "${DEFAULT_LOCALDATETIME_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当指定时间+x天后的日期 [String]<-(duration:Integer)
function localdatetime_plusWeek(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "duration[day] can not be null"
  local myLocaldate=$1 ; local duration=$2
  gdate -d "${myLocaldate} ${duration} week" "${DEFAULT_LOCALDATETIME_FORMAT}"
}
# 返回值格式 yyyyMMdd
# 当指定时间+x月后的日期 [String]<-(duration:Integer)
function localdatetime_plusMonth(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "duration[month] can not be null"
  local myLocaldate=$1 ; local duration=$2
  gdate -d "${myLocaldate} ${duration} month" "${DEFAULT_LOCALDATETIME_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当指定时间+x年后的日期 [String]<-(duration:Integer)
function localdatetime_plusYear(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "duration[year] can not be null"
  local myLocaldate=$1 ; local duration=$2
  gdate -d "${myLocaldate} ${duration} year" "${DEFAULT_LOCALDATETIME_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当指定时间+x年后的日期 [String]<-(duration:Integer)
function localdatetime_plus(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "duration can not be null"
  local myLocaldate=$1 ; local duration=$2
  gdate -d "${myLocaldate} ${duration}" "${DEFAULT_LOCALDATETIME_FORMAT}"
}

# 指定时间转换成指定格式
function localdatetime_format(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "format can not be null"
  gdate -d "$1" "$2"
}

function localdatetime_timestamp(){ _NotBlank "$1"
  local localdate=$(localdatetime_format "$1" "${DEFAULT_LOCALDATETIME_FORMAT}")
  gdate -d "${localdate}" +%s
}

localdatetime_isEqual(){ _NotBlank "$1" && _NotBlank "$2"
  local time1=$(localdatetime_timestamp "$1")
  local time2=$(localdatetime_timestamp "$2")

  if [[ ${time1} -eq ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}

localdatetime_isAfter(){ _NotBlank "$1" && _NotBlank "$2"
  local time1=$(localdatetime_timestamp "$1")
  local time2=$(localdatetime_timestamp "$2")

  if [[ ${time1} -gt ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}
localdatetime_isBefore(){ _NotBlank "$1" && _NotBlank "$2"
  local time1=$(localdatetime_timestamp "$1")
  local time2=$(localdatetime_timestamp "$2")

  if [[ ${time1} -lt ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}

localdatetime_now_isEqual(){ _NotBlank "$1" && _NotBlank "$2"
  local time1=$(localdatetime_now_timestamp)
  local time2=$(localdatetime_timestamp "$1")

  if [[ ${time1} -eq ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}

localdatetime_now_isAfter(){ _NotBlank "$1"
  local time1=$(localdatetime_now_timestamp)
  local time2=$(localdatetime_timestamp "$1")

  if [[ ${time1} -gt ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}
localdatetime_now_isBefore(){ _NotBlank "$1"
  local time1=$(localdatetime_now_timestamp)
  local time2=$(localdatetime_timestamp "$1")

  if [[ ${time1} -lt ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}

# 两个时间之间差多少s
function localdatetime_duration(){ _NotBlank "$1"
  local time1=$(localdatetime_timestamp "$1")
  local time2=$(localdatetime_timestamp "$2")

  echo $((time2-time1))
}