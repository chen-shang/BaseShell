#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
source ./../../BaseShell/Date/BaseTimeUnit.sh
#===============================================================

# 格式 2018-03-09T00:53:26
# 当前日期:时间 [String]<-()
function localdatetime_now(){
  date ${DEFAULT_LOCALDATETIME_FORMAT}
}

function localdatetime_now_timestamp(){
  date +%s
}

# 格式 2018-03-09T00:53:26
# 当前日期:时间 [String]<-()
function localdatetime_now_hour(){
  date +%H
}

# 格式 2018-03-09T00:53:26
# 当前日期:时间 [String]<-()
function localdatetime_now_minute(){
  date +%M
}

# 格式 2018-03-09T00:53:26
# 当前日期:时间 [String]<-()
function localdatetime_now_second(){
  date +%S
}
