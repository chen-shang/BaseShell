#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Date/BaseLocalDateTime.sh
#===============================================================
test-localdate(){

  timestamp_toLocaldate $(timestamp_now)

  localdatetime_getLocaldate "2019/10/01"
  localdatetime_getLocaltime "2019/10/01T10:23"

}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh