#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
source ./../../BaseShell/Utils/BaseHeader.sh

# @attention list最大长度255
# @attention list本身不能带空格
# @attention list的传递方式
#===============================================================

# @return a new list with your element
function new_arrayList(){
  local array=($1)
  echo $(echo "${array[*]}")
}

# @param e element to be appended to this list
function list_add(){
  local array=($1)
  echo $(echo "${array[*]} $2")
}

# @return the number of elements in this list
function list_size(){
  local array=($1);local size=${#array[*]}
  echo "${size}"
}

# @return ${TRUE} if this list contains no elements
function list_isEmpty(){
  local array=($1);local size=${#array[@]}
  [[ ${size} -eq 0 ]] && echo "${TRUE}" || echo "${FALSE}"
}

# @return ${TRUE} if this list contains the specified element
function list_contains(){
  _NotNull $1
  local array=($1);local target=$2
  if [[ "${array[*]/${target}/}" != "${array[*]}" ]];then echo "${TRUE}" else echo "${FALSE}";fi
}

# @return the element at the specified position in this list
function list_get(){
  _NotNull $1 && _NotNull $2
  local array=($1);local index=$2
  echo "${array[${index}]}"
}

# @return a new list
function list_set(){
  _NotNull $1 && _NotNull $2 && _NotNull $3
  local array=($1);local index=$2;local target=$3
  array[index]="${target}"
  echo "${array[*]}"
}

# 从列表中删除指定元素
function list_remove_o(){
  local array=($1);local target=$2
  echo "${array[*]}"|sed "s/${target}//g"
}

# 从列表中移除指定下标元素
function list_remove_i(){
  _NotNull $1 && _NotNull $2
  local array=($1);local index=$2
  unset array["${index}"]
  echo "${array[*]}"
}

function list_clear(){
  _NotNull $1 && _NotNull $2
  new_arrayList ""
}

function list_forEach(){
  _NotNull $1 && _NotNull $2
  local array=($1);local action=$2
  for item in ${array[*]}; do
    "${action}" "${item}"
  done
}

function list_parallelForEach(){
  _NotNull $1 && _NotNull $2
  local array=($1);local action=${2}
  for item in ${array[*]}; do
    ("${action}" "${item}")&
  done
  wait
}

#
function list_indexOf(){
  _NotNull $1 && _NotNull $2
  local array=($1);local target=$2
  local size=$(list_size "${array[*]}")
  local result=-1
  for ((i=0;i<size;i++)); do
    if [[ "${array[${i}]}" == "${target}" ]] ;then
      result="${i}"
      break
    fi
  done
  echo "${result}"
}

function list_lastIndexOf(){
  _NotNull $1 && _NotNull $2
  local array=($1);local target=$2
  local size=$(list_size "${array[*]}")
  for ((i=size--;i>=0;i--)); do
    [[ "${array[${i}]}" == "${target}" ]] && echo "${i}" && return
  done
  echo "-1"
}

# 截取列表下标元素 从0开始
function list_subList(){
  _NotNull $1 && _NotNull $2 && _NotNull $3
  local array=($1);local form=$2 &&local to=$3
  echo "${array[*]:${form}:$((to-form+1))}"
}

function list_join(){
  _NotNull $1 && _NotNull $2
  local array=($1);local delimiter=$2
  local size=$(list_size "${array[*]}")
  local result=${array[0]}
  if [[ ${size} -gt 1 ]];then
    for ((i=1;i<size;i++));do
       result=${result}${delimiter}${array[i]}
    done
  fi
  echo "${result}"
}