#!/usr/bin/env bash

#################引入需要测试的脚本################
source ./../../BaseShell/Collection/BaseArrayList.sh
###################下面写单元测试#################
assertEquals(){
 $$
}
consumer(){
 log_info "consumer $1"
}

test-new_arrayList(){
  list=($(new_arrayList "1 "))
  assertEquals "${list[*]}" "1"

  list=($(list_add "${list[*]}" "1"))
  assertEquals "${list[*]}" "1 1"

  size=$(list_size "${list[*]}")
  assertEquals "${size}" "2"

  item=$(list_indexOf "${list[*]}" "1")
  assertEquals "${item}" "0"

  result=$(list_get "${list[*]}" 2) #越界,但不阻塞
  assertEquals "${result}" ""

  result=$(list_lastIndexOf "${list[*]}" 1)
  assertEquals "${result}" "1"

  list_parallelForEach "${list[*]}" "log_info"

  list=($(list_add "${list[*]}" "2"))
  list_forEach "${list[*]}" "consumer"

  isEmpty=$(list_isEmpty "${list[*]}")
  assertEquals "${isEmpty}" "${FALSE}"

  newList=($(new_arrayList))
  isEmpty=$(list_isEmpty "${newList[*]}")
  assertEquals "${isEmpty}" "${TRUE}"

  list=($(list_remove_i "${list[*]}" "1"))
  assertEquals "${list[*]}" "1 2"

  list=($(list_add "${list[*]}" "1"))
  list=($(list_add "${list[*]}" "1"))

  list=($(list_remove_o "${list[*]}" "1"))
  assertEquals "${list[*]}" "2" "list_remove_o"
}

###################上面写单元测试#################
source ./../../BaseShell/Utils/BaseTestUtil.sh