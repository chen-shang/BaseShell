#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Annotation/BaseAnnotation.sh
#===============================================================
test-_Min(){
  _Min "2" "3" >/dev/null 2>&1
  assertTrue "$?"
  _Min "2" "1" >/dev/null 2>&1
  assertFalse "$?"
  _Min "2" "2" >/dev/null 2>&1
  assertFalse "$?"
}

test-_Max(){
  _Max "2" "1" >/dev/null 2>&1
  assertTrue "$?"
  _Max "2" "3" >/dev/null 2>&1
  assertFalse "$?"
  _Max "2" "2" >/dev/null 2>&1
  assertFalse "$?"
}

test-_Natural(){
  _Natural "1"
  assertTrue "$?"

  _Natural "123"
  assertTrue "$?"

  _Natural "1.2" >/dev/null 2>&1
  assertFalse "$?"

  _Natural "-1.2" >/dev/null 2>&1
  assertFalse "$?"

  _Natural "1 " >/dev/null 2>&1
  assertFalse "$?"

  _Natural " 1 " >/dev/null 2>&1
  assertFalse "$?"

  _Natural "12 3" >/dev/null 2>&1
  assertFalse "$?"
}

test-_NotBlank(){
   _NotBlank "1" >/dev/null 2>&1
   assertTrue "$?"

   _NotBlank "" >/dev/null 2>&1
   assertFalse "$?"

   _NotBlank " " >/dev/null 2>&1
   assertFalse "$?"

   _NotBlank >/dev/null 2>&1
   assertFalse "$?"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh