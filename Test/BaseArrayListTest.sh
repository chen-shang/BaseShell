#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Collection/BaseArrayList.sh
#===============================================================
test-list(){
  # 这里会新建一个List,建议用在多线程模式下
  new_arrayList number #创建一个名为number的List
  number_add 1         #向个number中添加一个元素
  number_add 2         #向个number中添加一个元素
  
  local result=$(number_values)        #打印当前List
  assertEquals "${result}" "1 2"
  
  number_add 3         #向个number中添加一个元素
  local result=$(number_values)        #打印当前List
  assertEquals "${result}" "1 2 3"
  
  local result=$(number_get 0) #获取第一个元素
  assertEquals "${result}" "1"
  
  local result=$(number_get 1) #获取第二个元素
  assertEquals "${result}" "2"
  
  #定义一个函数,作用是求和
  add(){
    echo $(($1+$2))
  }
  local result=$(number_reducer add) #获取第二个元素
  assertEquals "${result}" "6"
  
  number_removeByIndex 0     #去除第一个元素
  local result=$(number_values)
  assertEquals "${result}" "2 3"
  
  local result=$(number_get 0) #获取第二个元素
  assertEquals "${result}" "2"
  
  local result=$(number_reducer add)
  assertEquals "${result}" "5"
}

test-list2(){
  # 这里直接用自带的List实现,建议用在单线程模式下
  list_add 1         #向个number中添加一个元素
  list_add 2         #向个number中添加一个元素
  
  local result=$(list_values)        #打印当前List
  assertEquals "${result}" "1 2"
  
  list_add 3         #向个number中添加一个元素
  local result=$(list_values)        #打印当前List
  assertEquals "${result}" "1 2 3"
  
  local result=$(list_get 0) #获取第一个元素
  assertEquals "${result}" "1"
  
  local result=$(list_get 1) #获取第二个元素
  assertEquals "${result}" "2"
  
  #定义一个函数,作用是求和
  add(){
    echo $(($1+$2))
  }
  local result=$(list_reducer add) #获取第二个元素
  assertEquals "${result}" "6"
  
  list_removeByIndex 0     #去除第一个元素
  local result=$(list_values)
  assertEquals "${result}" "2 3"
  
  local result=$(list_get 0) #获取第二个元素
  assertEquals "${result}" "2"
  
  local result=$(list_reducer add)
  assertEquals "${result}" "5"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh