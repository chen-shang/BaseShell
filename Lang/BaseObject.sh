#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Constant/BaseConstant.sh
#===============================================================

# @return {@code true} if the arguments are equal to each other
function equals(){
  local value1=$1 #一参
  local value2=$2 #二参

  local length1=${#value1}
  local length2=${#value2}
  if [[ "${length1}" -eq "${length2}" && "${value1}" == "${value2}"  ]];then
    return "${TRUE}"
  else
    return "${FALSE}"
  fi
}

# isEmpty ""  -> 0
# isEmpty " " -> 1
# isEmpty "1" -> 1
# isEmpty  1  -> 1
function isEmpty(){
  local param=$1
  # if[[ -z ${value} ]] 中 -z 代表判断字符串的长度是否为0
  [[ -z "${param}" ]] && return "${TRUE}" || return "${FALSE}"
}

# isNotEmpty ""  -> 1
# isNotEmpty " " -> 0
# isNotEmpty "1" -> 0
# isNotEmpty  1  -> 0
function isNotEmpty(){
  local param=$1
  ! isEmpty "${param}"
}

# isBlank ""  -> 0
# isBlank " " -> 0
# isBlank "1" -> 1
# isBlank  1  -> 1
function isBlank(){
  local param=$1
  param=$(echo "$1" | tr -d " ")
  isEmpty "${param}" && return "${TRUE}" || return "${FALSE}"
}

# isNotBlank ""  -> 1
# isNotBlank " " -> 1
# isNotBlank "1" -> 0
# isNotBlank  1  -> 0
function isNotBlank(){
  local param=$1
  param=$(echo "$1" | tr -d " ")
  ! isBlank "${param}"
}

# isNull "null"  -> 0
# isNull " " -> 1
# isNull "1" -> 1
# isNull  1  -> 1
function isNull(){
  local param=$1
  local param=$*
  # if[[ -z ${value} ]] 中 -z 代表判断字符串的长度是否为0
  [[ "${param}" == "${NULL}" ]] && return "${TRUE}" || return "${FALSE}"
}

# isNotNull "null"  -> 1
# isNotNull " " -> 0
# isNotNull "1" -> 0
# isNotNull  1  -> 0
function isNotNull(){
  local param=$1
  local param=$*
  # if[[ -z ${value} ]] 中 -z 代表判断字符串的长度是否为0
  [[ "${param}" != "${NULL}" ]] && return "${TRUE}" || return "${FALSE}"
}

# 是否自然数
function isNatural(){ _NotBlank "$1" "param can not be null"
  local param=$1
  grep -q '^[[:digit:]]*$' <<< "${param}" && return "${TRUE}" || return "${FALSE}"
}

# 哈希code  [String]<-(str:String)
function hashCode(){
  local param=$1
  _action(){
    local param=$1
    local hash=0
    local i;for (( i=0; i<${#param}; i++ )); do
      printf -v val "%d" "'${param:$i:1}" # val is ASCII val
      if ((31 * hash + val > 2147483647)); then
        # hash scheme
        hash=$((- 2147483648 + ( 31 * hash + val ) % 2147483648))
      elif ((31 * hash + val < - 2147483648)); then
        hash=$((2147483648 - ( 31 * hash + val ) % 2147483648))
      else
        hash=$((31 * hash + val))
      fi
    done
    printf "%d" "${hash}" # final hashCode in decimal
  }
  pip "${param}"
}

# 这是一个辅助函数,意思是被其他函数调用的函数,以扩展原来函数的功能
# 1. 有参数的时候直接走 _action 否则执行2
# 2. 从标准输出中获取参数,并执行_action
# 该方法扩展原函数,使其具备从标准输出获取参数的能力,因此原函数可以类似管道似的调用.
# @see BaseString.sh trim|string_length
# @attention 从标准输入读取的参数是以空格分隔的 echo "1 2" "3 4"|trim 最终读取到的参数是 "1 2 3 4" 而不是 "1 2" 和 "3 4"
# 适用于明确只有一个参数的情况
function pip(){
  local param=$*
  #参数长度==0 尝试从标准输出获取参数
  if [[ ${#param} -eq 0 ]];then
    # timeout 设置1秒的超时
    param=$(timeout 0.1 cat <&0)
  fi
  _action "${param}"
}

function pip2(){
  local param1=$1
  local param2=$2
  #参数长度==0 尝试从标准输出获取参数
  if [[ ${#param2} -eq 0 ]];then
     # timeout 设置1秒的超时
     param2=$(timeout 1 cat <&0)
  fi

  _action "${param1}" "${param2}"
}

function pip3(){
  local param1=$1
  local param2=$2
  local param3=$3
  #参数长度==0 尝试从标准输出获取参数
  if [[ ${#param3} -eq 0 ]];then
     # timeout 设置1秒的超时
     param3=$(timeout 1 cat <&0)
  fi

  _action "${param1}" "${param2}"  "${param3}"
}

# 获取一个可用的文件描述符号
function new_fd(){
  {
    flock 3
    local find=${NULL}
    for((fd=4;fd<1024;fd++));do
      local rco="$(true 2>/dev/null >& ${fd}; echo $?)"
      local rci="$(true 2>/dev/null <& ${fd}; echo $?)"
      [[ "${rco}${rci}" == "11" ]] && find=${fd} && break
    done
    echo "${find}"
  } 3<>/tmp/base_shell.lock
}

isExist(){ _NotBlank "$1" "fd can not be null"
  local fd=$1
  {
    flock 3
    [[ -z "${fd}" ]] && { echo "fd can not be blank" ;exit ; }

    local rco=$(true 2>/dev/null >& "${fd}"; echo $?)
    local rci=$(true 2>/dev/null <& "${fd}"; echo $?)
    [[ "${rco}${rci}" == "00" ]] && return ${TRUE} || return ${FALSE}
  } 3<>/tmp/base_shell.lock
}


# 那文件描述符关联一个fifo,不关心文件名字
function new_fifo(){ _NotBlank "$1" "fd can not be null"
  local fd=$1
  [[ -z "${fd}" ]] && { echo "fd can not be blank" ;exit ; }

  {
    flock 3
    local rco=$(true 2>/dev/null >& "${fd}"; echo $?)
    local rci=$(true 2>/dev/null <& "${fd}"; echo $?)
    [[ "${rco}${rci}" == "00" ]] && return #存在则退出

    # 不存在则关联一个fifo有名管道
    local fifo=$(uuidgen)
    [[ -e "${fifo}" ]] || mkfifo "${fifo}"
    eval "exec ${fd}<>${fifo} && rm -rf ${fifo}"
  } 3<>/tmp/base_shell.lock
}

# 重命名函数
function new_function(){ _NotBlank "$1" "source function name can not be null" && _NotBlank "$2" "target function name can not be null"
  test -n "$(declare -f $1)" || return
  eval "${_/$1/$2}"
}

readonly -f isEmpty isNotEmpty isBlank isNotBlank new_function
readonly -f hashCode equals pip new_fd new_fifo
