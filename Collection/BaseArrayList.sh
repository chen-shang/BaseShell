#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155

# 注: 数组最大长度255
#${arrayList[*]} 数组的传递方式
source ./../../BashShell/Utils/BaseHeader.sh

#list 本身不能带空格
######################################################################

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
  ^NotNull $1
  local array=($1);local target=$2
  if [[ "${array[*]/${target}/}" != "${array[*]}" ]];then echo "${TRUE}" else echo "${FALSE}";fi
}

# @return the element at the specified position in this list
function list_get(){
  ^NotNull $1 && ^NotNull $2
  local array=($1);local index=$2
  echo "${array[${index}]}"
}

# @return a new list
function list_set(){
  ^NotNull $1 && ^NotNull $2 && ^NotNull $3
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
  ^NotNull $1 && ^NotNull $2
  local array=($1);local index=$2
  unset array["${index}"]
  echo "${array[*]}"
}

function list_clear(){
  ^NotNull $1 && ^NotNull $2
  new_arrayList ""
}

function list_forEach(){
  ^NotNull $1 && ^NotNull $2
  local array=($1);local action=$2
  for item in ${array[*]}; do
    "${action}" "${item}"
  done
}

function list_parallelForEach(){
  ^NotNull $1 && ^NotNull $2
  local array=($1);local action=${2}
  for item in ${array[*]}; do
    ("${action}" "${item}")&
  done
  wait
}

#
function list_indexOf(){
  ^NotNull $1 && ^NotNull $2
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
  ^NotNull $1 && ^NotNull $2
  local array=($1);local target=$2
  local size=$(list_size "${array[*]}")
  for ((i=size--;i>=0;i--)); do
    [[ "${array[${i}]}" == "${target}" ]] && echo "${i}" && return
  done
  echo "-1"
}

# 截取列表下标元素 从0开始
function list_subList(){
  ^NotNull $1 && ^NotNull $2 && ^NotNull $3
  local array=($1);local form=$2 &&local to=$3
  echo "${array[*]:${form}:$((to-form+1))}"
}

function list_join(){
  ^NotNull $1 && ^NotNull $2
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