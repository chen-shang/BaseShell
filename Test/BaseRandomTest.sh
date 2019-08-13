#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Utils/BaseRandom.sh
#===============================================================
test-random_int(){
  local int=$(random_int 1)
  assertEquals "${int}" "1"

  local int=$(random_int 10)
  local result=${FALSE}
  if [[ ${int} -le 10 ]];then
    result=${TRUE}
  fi
  assertTrue ${result}

  int=$(random_int)
  assertNotNull "${int}"
}

test-random_string(){
  local string=$(random_string 16)
  assertNotNull "${string}"
  string=$(random_string)
  assertNotNull "${string}"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
