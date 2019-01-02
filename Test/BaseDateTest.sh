#!/usr/bin/env bash

#################引入需要测试的脚本################
source ./../../BaseShell/Date/BaseLocalDate.sh
source ./../../BaseShell/Date/BaseLocalDateTime.sh
source ./../../BaseShell/Date/BaseLocalTime.sh
source ./../../BaseShell/Date/BaseMonth.sh
source ./../../BaseShell/Date/BaseWeek.sh
source ./../../BaseShell/Date/BaseCalendar.sh
###################下面写单元测试#################
myLocaldate="2018-01-02"
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
source ./../../BaseShell/Utils/BaseTestUtil.sh