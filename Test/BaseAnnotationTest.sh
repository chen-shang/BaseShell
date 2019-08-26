#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Annotation/BaseAnnotation.sh
#===============================================================
test-_Min(){ #ignore
  _Min "2" "3"
  assertEquals $? "0"
  _Min "2" "1"
}

test-_Max(){ #ignore
  _Max "2" "1"
  assertEquals $? "0"
  _Max "2" "3"
}

test-_Natural(){
  _Natural "1"
  assertTrue $?

  _Natural "123"
  assertTrue $?

  (_Natural "1.2" >/dev/null 2>&1)
  assertFalse $?

  (_Natural "-1.2" >/dev/null 2>&1)
  assertFalse $?

  (_Natural "1 " >/dev/null 2>&1)
  assertFalse $?

  (_Natural " 1 " >/dev/null 2>&1)
  assertFalse $?

  (_Natural "12 3" >/dev/null 2>&1)
  assertFalse $?
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
