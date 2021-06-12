#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Date/BaseLocalDateTime.sh
#===============================================================
test-localdate(){
  localdatetime_now_isAfter "2019-09-12T13:23:01" && echo yes || echo no
  localdate_now_isAfter "20190912" && echo yes || echo no
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh