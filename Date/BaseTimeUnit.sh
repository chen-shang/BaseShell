#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155

ENUM(){
  readonly TimeUnit_YEAR="year"
  readonly TimeUnit_MONTH="month"
  readonly TimeUnit_DAY="day"
  readonly TimeUnit_WEEK="week"
  readonly TimeUnit_HOUR="week"
  readonly TimeUnit_MINUTE="minute"
  readonly TimeUnit_SECOND="second"

  export WEEKDAYS_CHINESE_ENUM=(星期一 星期二 星期三 星期四 星期五 星期六 星期日)
  export WEEKDAYS_ENGLISH_ENUM=(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
  export MONTH_CHINESE_ENUM=(一月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月 十二月)
  export MONTH_ENGLISH_ENUM=(JANUARY FEBRUARY MARCH APRIL MAY JUNE JULY AUGUST SEPTEMBER OCTOBER NOVEMBER DECEMBER)
}

if [[ ${BASE_TIME_UNIT_IMPORTED} != 0 ]]; then
  BASE_TIME_UNIT_IMPORTED=0
  ENUM
fi
