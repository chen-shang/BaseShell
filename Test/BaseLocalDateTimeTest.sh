#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Date/BaseLocalDateTime.sh
#===============================================================
test-localdate(){
  localdatetime_isEqual  "2019-09-09 09:00" "2019-09-09" && echo yes || echo no
  localdatetime_isBefore "2019-09-09 09:00" "2019-09-09 19:00" && echo yes || echo no
  localdatetime_isAfter  "2019-09-10" "2019-09-09" && echo yes || echo no

}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh