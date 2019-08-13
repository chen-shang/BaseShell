#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Annotation/BaseAnnotation.sh
#===============================================================
test-_Min(){
  _Min "2" "10"
  assertEquals $? "0"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
