#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2207,SC2178,SC2128,SC2179

######################################################################
#使用数组结构模拟JAVA中的HashMap实现
#JAVA中的HashMap在hash冲突的时候使用链表,这里使用->串联的字符串模拟JAVA中的链表,如([0]=[k1=v1]->[k2=v2] [1]=[one=1]->[two=2])
#JAVA中HashMap的扩容有一个阈值,这里为了减少参数的传递,废除了这一规则,当HashMap中值的个数达到 16,32,64,128的时候就会自动扩容为原来的两倍
######################################################################
source ./../../BaseShell/Utils/BaseHeader.sh
source ./../../BaseShell/Lang/BaseString.sh
source ./../../BaseShell/Lang/BaseMath.sh
source ./../../BaseShell/Collection/BaseArrayList.sh
# @return a hash map
function new_hashMap(){
  # 使用[]占位符,这样才能获取到传入参数中hashMap桶的大小,不得已而为之
#  echo "[] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] [] []"
  echo "[] [] [] []"

}

private_map_bucketSize(){
  local hashMap=($1)
  local size=$(echo "${hashMap[*]}"|awk '{print NF}')
  echo "${size}"
}

function map_pure(){
  local map=("$*")
  # 去掉 [] 占位符,合并多个空格
  echo "${map[*]}"|tr -d '[]'|column -t |tr -s ' '
}

# @return the number of key-value mappings in this map
function map_size(){
  local map=("$*")
  local size=$(map_pure "${map[*]}"|tr  "\\${NEXT}" " "|awk '{print NF}')
  echo "${size}"
}
map_clear(){
  local map=("$*")
  local clearHashMap=$(echo "${map[*]}"|awk '{for(i=0;i<NF;i++){print "[]"}}')
  echo "${clearHashMap}"
}
private_map_reHash(){
  local map=($1)
  local bucketSize=$((2*$(private_map_bucketSize "${map[*]}"))) #map桶的大小,也就是当前map可以数组的大小
  local clearMap=$(map_clear "${map[*]}")
  local newHashMap="${clearMap} ${clearMap}" #扩容两倍
  map=($(map_pure "${map[*]}"))
  for head in ${map[*]};do
    local linkList=($(echo "${head}"|tr "\\${NEXT}" " "))
      for item in ${linkList[*]};do
        local k=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $1}')
        local v=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $2}')
        local hash=$(hashCode "${k}")
        local index=$((hash % bucketSize))
        newHashMap=$(private_map_putVal "${newHashMap}" "${index}" "${k}" "${v}" "${FALSE}")
      done
  done
  echo "${newHashMap}"
}

# @return the map which add the new element
function map_put(){
  local map=($1) #第一个参数为要操作的map
  local key=$2 #第二个参数是要put的key
  local value=$3 #第二个参数是要put的key对应的value
  local size=$(map_size "${map[*]}") #当前map的数量,当2^n的时候,开始扩容
  local bucketSize=$(private_map_bucketSize "${map[*]}") #map桶的大小,也就是当前map可以数组的大小

  local needReHash=${FALSE}
  [[ $((size+1)) -gt ${bucketSize} ]] && needReHash=${TRUE} #在添加一个就要扩容了

  if [[ ${needReHash} -eq ${TRUE} ]];then
    bucketSize=$((2*bucketSize))
    map=($(private_map_reHash "${map[*]}"))
  fi

  local hash=$(hashCode "${key}") #计算key的hash
  local index=$((hash%bucketSize))
  map=($(private_map_putVal "${map[*]}" "${index}" "${key}" "${value}" "${FALSE}"))
  echo "${map[*]}"
}

private_map_putVal(){
  local map=($1)
  local index=$2
  local key=$3
  local value=$4
  local putIfAbsent=$5 #FALSE存在则替换,TRUE存在则不变,默认FALSE

  local head=${map[${index}]}
  if [[ ${head} == "[]" ]];then
    head="[${key}=${value}]"
  else
    # hash冲突
    local linkList=($(echo "${head}"|tr "\\${NEXT}" " "))
    local listSize=$(list_size "${linkList[*]}")
    local newLinkList=("[${key}=${value}]")
    for ((i=0;i<listSize;i++));do
      local item=${linkList[i]}
      k=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $1}')
      if [[ "${k}" == "${key}" ]] && [[ ${putIfAbsent} -eq ${TRUE} ]];then
         newLinkList[0]=${item}
        continue
      else
        newLinkList[i+1]=${item}
      fi
    done
    head=$(list_join "${newLinkList[*]}" "${NEXT}")
  fi
  map[index]="${head}"
  echo "${map[*]}"
}

# @return ${TRUE} if this map contains no key-value mappings
function map_isEmpty(){
  local array=("$*")
  local size=${#array[@]}
  [[ ${size} -eq 0 ]] && echo "${TRUE}" || echo "${FALSE}"
}

function map_get(){
  local map=($1) #第一个参数为要操作的map
  local key=$2 #第二个参数是要get的key
  local hashCode=$(hashCode "${key}")

  local maxSize=$(private_map_bucketSize "${map[*]}")
  local index=$((hashCode%maxSize))

  local head="${map[index]}"

  local value
  if [[ ${head} != "[]" ]];then
    local linkList=($(echo "${head}"|tr "\\${NEXT}" " "))
    for item in ${linkList[*]};do
      k=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $1}')
      if [[ "${k}" == "${key}" ]];then
         v=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $2}')
         value="${v}"
         break
      fi
    done
  fi
  echo "${value}"
}

function map_values(){
  local map=($1)
  map=($(private_map_pure "${map[*]}"))
  local values
  for head in ${map[*]};do
    local linkList=($(echo "${head}"|tr "\\${NEXT}" " "))
    for item in ${linkList[*]};do
      v=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $2}')
      values+="${v} "
    done
  done
  echo "${values}"
}

function map_keys(){
  local map=($1)
  map=($(private_map_pure "${map[*]}"))  local values
  for head in ${map[*]};do
    local linkList=($(echo "${head}"|tr "\\${NEXT}" " "))
    for item in ${linkList[*]};do
      k=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $1}')
      values+="${k} "
    done
  done
  echo "${values}"
}

# @return ${TRUE} if this map contains a mapping for the specified
function map_containsKey(){
  local map=($1) && local k=$2
  local keys=$(map_keys "${map[*]}")
  string_contains "${keys}" "${k}"
}

# @return ${TRUE} if this map maps one or more keys to the
function map_containsValue(){
  local map=($1) && local v=$2
  local keys=$(map_values "${map[*]}")
  string_contains "${keys}" "${v}"
}

function map_remove() {
  local map=($1) #第一个参数为要操作的map
  local key=$2 #第二个参数是要remove的key
  local contain=$(map_containsKey "${map[*]}" "${key}")
  if [[ ${contain} -ne ${TRUE} ]]; then
    echo "map[*]"
  else
    local hashCode=$(hashCode "${key}")
    local maxSize=$(private_map_bucketSize "${map[*]}")
    local index=$((hashCode % maxSize))
    local head="${map[index]}"
    local linkList=($(echo "${head}"|tr "\\${NEXT}" " "))
    local listSize=$(list_size "${linkList[*]}")
    local newLinkList="[]"
    for ((i=0;i<listSize;i++));do
      item=${linkList[i]}
      k=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $1}')
      if [[ "${k}" == "${key}" ]];then
        continue
      else
        if [[ $(string_equals "${newLinkList}" "[]") -eq ${TRUE}  ]];then
          newLinkList="${item}"
        else
          newLinkList+="${newLinkList}${NEXT}${item}"
        fi
      fi
    done
    head="${newLinkList}"
  fi
  map[index]="${head}"
  echo "${map[*]}"
}

function map_kv(){
  new_hashMap
}
function getOrDefault(){
  local map=($1) && local key=$2 && local default=$3
  local v=$(map_get "${map[*]}" "${key}")
  if [[ $(string_isBlank "${v}") -eq ${TRUE}  ]];then
    v=${default}
  fi
  echo "${v}"
}
consumer(){
  local k=$1
  local v=$2
  log_info  "kv=>${k}=${v}"
}
function map_forEach(){
  local map=($1)
  map=($(private_map_pure "${map[*]}"))
  local consumer=$2
  for head in ${map[*]};do
    local linkList=($(echo "${head}"|tr "\\${NEXT}" " "))
    for item in ${linkList[*]};do
      k=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $1}')
      v=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $2}')
      "${consumer}" "${k}" "${v}"
    done
  done
}

function map_parallelForEach(){
  local map=($1)
  map=($(private_map_pure "${map[*]}"))
  local consumer=$2
  for head in ${map[*]};do
    local linkList=($(echo "${head}"|tr "\\${NEXT}" " "))
    for item in ${linkList[*]};do
      k=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $1}')
      v=$(echo "${item}"|tr -d '[]'|awk -F '=' '{print $2}')
      ("${consumer}" "${k}" "${v}") &
    done
  done
  wait
}

function map_putIfAbsent(){
  local map=($1) #第一个参数为要操作的map
  local key=$2 #第二个参数是要put的key
  local value=$3 #第二个参数是要put的key对应的value
  local size=$(map_size "${map[*]}") #当前map的数量,当2^n的时候,开始扩容
  local bucketSize=$(private_map_bucketSize "${map[*]}") #map桶的大小,也就是当前map可以数组的大小
  local needReHash=${FALSE}
  [[ $((size+1)) -gt ${bucketSize} ]] && needReHash=${TRUE} #在添加一个就要扩容了
  log_trace "${LINENO} map=${map[*]},key=${key},value=${value},bucketSize=${bucketSize},size=${size},needReHash=${needReHash}"
  if [[ ${needReHash} -eq ${TRUE} ]];then
    bucketSize=$((2*bucketSize))
    log_trace "${LINENO} 扩容前map=${map[*]}"
    map=($(private_map_reHash "${map[*]}"))
    log_trace "${LINENO} 扩容后map=${map[*]}"
  fi

  local hash=$(hashCode "${key}") #计算key的hash
  local index=$((hash%bucketSize))
  log_trace "${LINENO} hash:${hash},bucketSize=${bucketSize},key=${key},value=${value},index=${index}"
  map=($(private_map_putVal "${map[*]}" "${index}" "${key}" "${value}" "${TRUE}"))
  echo "${map[*]}"
}