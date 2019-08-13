#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Annotation/BaseAnnotation.sh
#===============================================================
test-_Min(){
  _Min "2" "3"
  assertEquals $? "0"
  _Min "2" "1"
}

test-_Max(){
  _Max "2" "1"
  assertEquals $? "0"
  _Max "2" "3"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
