#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/Date/BaseTimeUnit.sh
source ./../../BaseShell/Date/BaseTimestamp.sh
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
# 格式 251
# 今天是一年的第几天
function localdate_now_dayOfYear(){
  gdate +%j
}
# 格式 Saturday
# 当前日期 [String]<-()
function localdate_getDayOfYear(){ _NotBlank "$1"
  gdate -d "$1" +%j
}
# 取出给的日期的年份
function localdate_getYear(){ _NotBlank "$1"
  gdate -d "$1" +%Y
}
# 取出给的日期的月份
function localdate_getMonth(){ _NotBlank "$1"
  gdate -d "$1" +%m
}
# 取出给的日期的日期
function localdate_getDay(){ _NotBlank "$1"
  gdate -d "$1" +%d
}
# 格式 Saturday
# 取出给的日期是星期几
function localdate_getWeek(){ _NotBlank "$1"
  gdate -d "$1" +%A
}

# 返回值格式 yyyyMMdd
# 当前时间+x天后的日期 [String]<-(duration:Integer)
function localdate_now_plusDay(){ _NotBlank "$1" "duration[day] can not be null"
  local duration=$1
  gdate -d "$(localdate_now) ${duration} day" "${DEFAULT_LOCALDATE_FORMAT}"
}
# 返回值格式 yyyyMMdd
# 当前时间+x天后的日期 [String]<-(duration:Integer)
function localdate_now_plusWeek(){ _NotBlank "$1" "duration[week] can not be null"
  local duration=$1
  gdate -d "$(localdate_now) ${duration} week" "${DEFAULT_LOCALDATE_FORMAT}"
}
# 返回值格式 yyyyMMdd
# 当前时间+x月后的日期 [String]<-(duration:Integer)
function localdate_now_plusMonth(){ _NotBlank "$1" "duration[month] can not be null"
  local duration=$1
  gdate -d "$(localdate_now) ${duration} month" "${DEFAULT_LOCALDATE_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当前时间+x年后的日期 [String]<-(duration:Integer)
function localdate_now_plusYear(){ _NotBlank "$1" "duration[year] can not be null"
  local duration=$1
  gdate -d "$(localdate_now) ${duration} year" "${DEFAULT_LOCALDATE_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当指定时间+x天后的日期 [String]<-(duration:Integer)
function localdate_plusDay(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "duration[day] can not be null"
  local myLocaldate=$1 ; local duration=$2
  gdate -d "${myLocaldate} ${duration} day" "${DEFAULT_LOCALDATE_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当指定时间+x天后的日期 [String]<-(duration:Integer)
function localdate_plusWeek(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "duration[day] can not be null"
  local myLocaldate=$1 ; local duration=$2
  gdate -d "${myLocaldate} ${duration} week" "${DEFAULT_LOCALDATE_FORMAT}"
}
# 返回值格式 yyyyMMdd
# 当指定时间+x月后的日期 [String]<-(duration:Integer)
function localdate_plusMonth(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "duration[month] can not be null"
  local myLocaldate=$1 ; local duration=$2
  gdate -d "${myLocaldate} ${duration} month" "${DEFAULT_LOCALDATE_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当指定时间+x年后的日期 [String]<-(duration:Integer)
function localdate_plusYear(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "duration[year] can not be null"
  local myLocaldate=$1 ; local duration=$2
  gdate -d "${myLocaldate} ${duration} year" "${DEFAULT_LOCALDATE_FORMAT}"
}

# 返回值格式 yyyyMMdd
# 当指定时间+x年后的日期 [String]<-(duration:Integer)
function localdate_plus(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "duration can not be null"
  local myLocaldate=$1 ; local duration=$2
  gdate -d "${myLocaldate} ${duration}" "${DEFAULT_LOCALDATE_FORMAT}"
}

# 指定时间转换成指定格式
function localdate_format(){ _NotBlank "$1" "date can not be null" &&  _NotBlank "$2" "format can not be null"
  gdate -d "$1" "$2"
}

function localdate_timestamp(){ _NotBlank "$1"
  local localdate=$(localdate_format "$1" "${DEFAULT_LOCALDATE_FORMAT}")
  gdate -d "${localdate}" +%s
}

localdate_isEqual(){ _NotBlank "$1" && _NotBlank "$2"
  local time1=$(localdate_timestamp "$1")
  local time2=$(localdate_timestamp "$2")

  if [[ ${time1} -eq ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}

localdate_isAfter(){ _NotBlank "$1" && _NotBlank "$2"
  local time1=$(localdate_timestamp "$1")
  local time2=$(localdate_timestamp "$2")

  if [[ ${time1} -gt ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}
localdate_isBefore(){ _NotBlank "$1" && _NotBlank "$2"
  local time1=$(localdate_timestamp "$1")
  local time2=$(localdate_timestamp "$2")

  if [[ ${time1} -lt ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}


localdate_now_isEqual(){ _NotBlank "$1"
  local time1=$(localdate_timestamp $(localdate_now))
  local time2=$(localdate_timestamp "$1")

  if [[ ${time1} -eq ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}

localdate_now_isAfter(){ _NotBlank "$1"
  local time1=$(localdate_timestamp $(localdate_now))
  local time2=$(localdate_timestamp "$1")

  if [[ ${time1} -gt ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}
localdate_now_isBefore(){ _NotBlank "$1"
  local time1=$(localdate_timestamp $(localdate_now))
  local time2=$(localdate_timestamp "$1")

  if [[ ${time1} -lt ${time2} ]];then
    return "${TRUE}"
  fi

  return "${FALSE}"
}

# 指定时间之间差几天
function localdate_duration(){  _NotBlank "$1" &&  _NotBlank "$2"
  local date1=$(localdate_getDayOfYear "$1")
  local date2=$(localdate_getDayOfYear "$2")
  echo $(( date2-date1 ))
}