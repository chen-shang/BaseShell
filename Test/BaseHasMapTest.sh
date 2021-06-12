#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Collection/BaseHasMap.sh
#===============================================================
test-hashMap(){
  hashMap_isEmpty  #一开始肯定是空的
  assertTrue "$?"
  
  hashMap_put "one" "1" # put 一个元素
  local keys=$(hashMap_keys)
  assertEquals "${keys}" "one" 
  local values=$(hashMap_values)
  assertEquals "${values}" "1"
  
  hashMap_put "two" "2" # put 一个元素
  local keys=$(hashMap_keys)
  assertEquals "${keys}" "two one" 
  local values=$(hashMap_values)
  assertEquals "${values}" "2 1"
  local kv=$(hashMap_toString)
  assertEquals "${kv}" "[one]=1 [two]=2"
  
  local value=$(hashMap_get "one") # get 一个元素
  assertEquals "${value}" "1"
  
  hashMap_isEmpty
  assertFalse "$?"
  
  printKv(){
    echo "$1:$2"
  }
  hashMap_forEach "printKv" #执行for循环
  
  hashMap_containsKey "one"
  assertTrue "$?"
  
  hashMap_containsValue "1"
  assertTrue "$?"
  
  hashMap_containsValue "不存在"
  assertFalse "$?"
  
  hashMap_remove "one"
  hashMap_kv
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh