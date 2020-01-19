#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Collection/BaseArrayList.sh
#===============================================================
test-list(){
  new_arrayList number
  number_add 1
  number_add 2
  add(){
    echo $(($1+$2))
  }
  number_reducer add
  number_get 0
}
test-list2(){
  list_add '1'
  list_add '2'
  list_add 'one'
  list_add 'two'
  list_values
  list_get 0
  list_get 1
  list_contains '1'
  list_contains 'three'
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh