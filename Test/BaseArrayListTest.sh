#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Collection/BaseArrayList.sh
#===============================================================
function fun(){
new_arrayList number
number_add 1
  number_add 2
  add(){
    echo $(($1+$2))
  }
  number_reducer add
}
test-list_reducer(){
fun
list_values

}



#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh