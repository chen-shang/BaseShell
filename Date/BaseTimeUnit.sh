#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155,SC2034
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================
readonly TimeUnit_YEAR="year"
readonly TimeUnit_MONTH="month"
readonly TimeUnit_DAY="day"
readonly TimeUnit_WEEK="week"
readonly TimeUnit_HOUR="hour"
readonly TimeUnit_MINUTE="minute"
readonly TimeUnit_SECOND="second"

readonly WEEKDAYS_CHINESE_ENUM=(星期一 星期二 星期三 星期四 星期五 星期六 星期日)
readonly WEEKDAYS_ENGLISH_ENUM=(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)

readonly MONTH_CHINESE_ENUM=(一月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月 十二月)
readonly MONTH_ENGLISH_ENUM=(JANUARY FEBRUARY MARCH APRIL MAY JUNE JULY AUGUST SEPTEMBER OCTOBER NOVEMBER DECEMBER)

# 格式 2018-03-09T00:53:26
readonly DEFAULT_LOCALDATETIME_FORMAT='+%Y-%m-%dT%H:%M:%S'
# 格式 2018-03-09
readonly DEFAULT_LOCALDATE_FORMAT="+%Y-%m-%d"
# 格式 2018-03-09
readonly DEFAULT_LOCALTIME_FORMAT="+%H:%M:%S"


function TimeUnit.MILLISECOND.sleep(){
  local sec=$(echo "scale=4;$1/1000"|bc)
  sleep "${sec}"
}

function TimeUnit.SECOND.sleep(){
  sleep "$1"
}

function TimeUnit.MINUTE.sleep(){
  sleep $(($1*60))
}

function TimeUnit.HOUR.sleep(){
  sleep $(($1*60*60))
}
