#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
source ./../../BaseShell/Date/BaseTimeUnit.sh
#===============================================================================
function timestamp_now_localdatetime(){
  gdate -d "@$1" "${LOCALDATETIME_FORMAT}"
}