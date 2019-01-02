#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155

source ./../../BaseShell/Date/BaseTimeUnit.sh
LOCALDATETIME_FORMAT='+%Y-%m-%dT%H:%M:%S'
# 格式 2018-03-09T00:53:26
# 当前日期:时间 [String]<-()
function localdatetime_now(){
  gdate ${LOCALDATETIME_FORMAT}
}

function localdatetime_now_timestamp(){
  gdate +%s
}

function timestamp_now_localdatetime(){
  gdate -d "@$1" "${LOCALDATETIME_FORMAT}"
}