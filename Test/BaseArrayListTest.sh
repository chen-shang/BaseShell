#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Collection/BaseArrayList.sh
#===============================================================
test-list_reducer(){
  list_add 1
  list_add 2

  list_reducer add
}

add(){
  echo $(($1+$2))
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh