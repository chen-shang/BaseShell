#!/usr/bin/env bash

#################引入需要测试的脚本################
source ./../../BashShell/Date/BaseLocalDate.sh
source ./../../BashShell/Date/BaseLocalDateTime.sh
source ./../../BashShell/Date/BaseLocalTime.sh
source ./../../BashShell/Date/BaseMonth.sh
source ./../../BashShell/Date/BaseWeek.sh
source ./../../BashShell/Date/BaseCalendar.sh
###################下面写单元测试#################
myLocaldate="2018-11-02"
localdate_of "${myLocaldate}"
${myLocaldate} getDayOfYear

localdate_yearOf "${myLocaldate}"
localdate_dayOf "${myLocaldate}"
localdate_plus "${myLocaldate}" "-1" "${TimeUnit_DAY}"
localdate_plus "${myLocaldate}" "1" "${TimeUnit_YEAR}"
myLocalTime="00:11:11"
localtime_plus ${myLocalTime} "10" "${TimeUnit_MINUTE}"

localdatetime_now_timestamp

timestamp_now_localdatetime "1542993787"
###################上面写单元测试#################
source ./../../BashShell/Utils/BaseTestUtil.sh