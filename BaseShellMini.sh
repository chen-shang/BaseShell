#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================

#==========================BaseConstant.sh=====================================
readonly TRUE=0                         # Linux 中一般0代表真非0代表假
readonly FALSE=1
readonly NONE=''
readonly NULL='null'
readonly PI=3.14159265358979323846
readonly E=2.7182818284590452354

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

function isNatural(){ _NotBlank "$1"
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
    param=$(timeout 1 cat <&0)
  fi
  _action "${param}"
}

# 重命名函数
function new_function(){ _NotBlank "$1" "source function name can not be null" && _NotBlank "$2" "target function name can not be null"
  test -n "$(declare -f $1)" || return
  eval "${_/$1/$2}"
}

readonly -f isEmpty isNotEmpty isBlank isNotBlank new_function
readonly -f hashCode equals pip
#==========================BaseAnnotation.sh=====================================
# 判断传入参数是否为空 [Boolean]<-(param:String,err_msg:String)
function _NotBlank(){
  local param=$(echo $1|trim);local err_msg=$2
  err_msg=${err_msg:-'parameter can not be null'}
  [[ -z "${param}" ]] && log_fail "${err_msg}" || return ${TRUE}
}

# 判断传入参数是否为自然数 [Boolean]<-(param:String,err_msg:String)
function _Natural(){
  local param=$1;local err_msg=$2
  err_msg=${err_msg:-'parameter must be numeric'}
  ! grep -q '^[[:digit:]]*$' <<< "${param}" && log_fail "${err_msg}" || return "${TRUE}"
}

# @param $1:最小值 $2:参数值 $3:err_msg
# 最大不得小于此最小值 [Boolean]<-(Number,Number,String)
function _Min(){ _NotBlank "$1" ; _NotBlank "$2"
  local err_msg=$3
  err_msg=${err_msg:-"value can not be less than $1"}
  # $2:参数值 < $1:最小值
  # 注意bc计算器0代表假，1代表真
  [[ $(echo "$2 <= $1" | bc) -eq 1 ]] && log_fail "${err_msg}" || return "${TRUE}"
}

# @param $1:最大值 $2:参数值 $3:err_msg
# 最大不得超过此最大值 [Boolean]<-(Number,Number,String)
function _Max(){ _NotBlank "$1" ; _NotBlank "$2"
  local err_msg=$3
  err_msg=${err_msg:-"value can not be bigger than  $1"}
  # $2:参数值 > $1:最大值
  # 注意bc计算器0代表假，1代表真
  [[ $(echo "$2 >= $1" | bc) -eq 1 ]] && log_fail "${err_msg}" || return "${TRUE}"
}


# 去掉字符串前后空格 [String]<-(param:String)
function trim(){
  local param=$*
  _action(){
    local param=$*
    echo -e "${param}" | grep -o "[^ ]\+\( \+[^ ]\+\)*"
  }
  pip "${param}"
}

# 转大写
function toUpperCase(){
  local param=$*
  _action(){
    local param=$*
    echo -e "${param}" | tr '[:lower:]' '[:upper:]'
  }
  pip "${param}"
}

# 转小写
function toLowerCase(){
  local param=$*
  _action(){
    echo -e "${param}" | tr '[:upper:]' '[:lower:]'
  }
  pip "${param}"
}

# 日志记录位置
LOG_DIR="${HOME}/.baseshell"

# ERROR<WARN<INFO<DEBUG
case ${LOG_LEVEL} in
   "ERROR" ) log_level=0 ;;
   "WARN"  ) log_level=1 ;;
   "INFO"  ) log_level=2 ;;
   "DEBUG" ) log_level=3 ;;
   "SYSTEM") log_level=4 ;;
   *) log_level=2 ;;
esac

# 默认关闭,debug级别的日志会忽略
# debug级别的日志 []<-(msg:String)
function log_debug(){
  if [[ ${log_level} -ge 3 ]];then
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [DEBUG] [${FUNCNAME[1]}]:   $*"|trim 1>&2
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [DEBUG] [${FUNCNAME[1]}]:   $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).debug.log" 2>&1
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [DEBUG] [${FUNCNAME[1]}]:   $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
  fi
}

# info级别的日志 []<-(msg:String)
function log_info(){
  if [[ ${log_level} -ge 2 ]];then
    echo -e "\\033[37m[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [INFO] [${FUNCNAME[1]}]:    $*\\033[0m"|trim 1>&2
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [INFO] [${FUNCNAME[1]}]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).info.log"  2>&1
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [INFO] [${FUNCNAME[1]}]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log"  2>&1
  fi
}

# warn级别的日志 []<-(msg:String)
function log_warn(){
  if [[ ${log_level} -ge 2 ]];then
    echo -e "\033[33m[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [WARN] [${FUNCNAME[1]}]:    $*\033[0m"|trim 1>&2
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [WARN] [${FUNCNAME[1]}]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).info.log" 2>&1
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [WARN] [${FUNCNAME[1]}]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
  fi
}

# error级别的日志 []<-(msg:String)
function log_error(){
  if [[ ${log_level} -ge 0 ]];then
    echo -e "\\033[31m[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [ERROR] [${FUNCNAME[1]}]:   $*\\033[0m"|trim 1>&2
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [ERROR] [${FUNCNAME[1]}]:   $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).error.log" 2>&1
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [ERROR] [${FUNCNAME[1]}]:   $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
  fi
}

# 用来标识成功状态的,用绿色 []<-(msg:String)
function log_success(){
  if [[ ${log_level} -ge 2 ]];then
    echo -e "\\033[32m[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [SUCCESS] [${FUNCNAME[1]}]: $*\\033[0m"|trim 1>&2
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [SUCCESS] [${FUNCNAME[1]}]: $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).info.log" 2>&1
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [SUCCESS] [${FUNCNAME[1]}]: $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
  fi
}

# @attention 当前子进程会退出
# 用来标识失败状态的,用红色, []<-(msg:String)
function log_fail(){
  if [[ ${log_level} -ge 2 ]];then
    echo -e "\\033[31m[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [FAIL] [${FUNCNAME[1]}]:    $*\\033[0m"|trim 1>&2
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [FAIL] [${FUNCNAME[1]}]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).info.log" 2>&1
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [FAIL] [${FUNCNAME[1]}]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
    exit 1
  fi
}

# base内部系统级别的日志 []<-(msg:String)
# 一般不用打开,看一眼
function log_system(){
  if [[ ${log_level} -ge 4 ]];then
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [SYSTEM] [${FUNCNAME[1]}]:    $*"|trim 1>&2
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [SYSTEM] [${FUNCNAME[1]}]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).info.log" 2>&1
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [SYSTEM] [${FUNCNAME[1]}]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
  fi
}

# @attention 日志只会输出到日志文件中,不会输出在控制台上,默认开启
# 用来标识追踪日志 []<-(msg:String)
function log_trace(){
  echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID] [TRACE] [${FUNCNAME[1]}]:   $*"|trim >>"${LOG_DIR}/$(date +%Y-%m-%d)".trace.log 2>&1
}

# 这串代码特别简单，就是利用RANDOM这个随机数生成器进行取余就能够实现，至于为什么取余时需要+1是因为在取余时如果被整除那么余数会是0，这样就不在限定范围内了
# RANDOM 0~32767 之间的一个整数
# seed: 种子,随机数有可能等于seed
# 产生一个随机数 []->(seed:int)
function random_int(){
  local seed=${1:-65536}
  echo $((RANDOM%seed))
}

# 产生一个随机未字符串 base32
function random_string(){
  local length=${1:-16}
  head -c ${length} /dev/random |base32
}

# 产生随机一句话
random_word(){
  #木芽一言 https://api.xygeng.cn/dailywd/?pageNum=320
  curl -s https://api.xygeng.cn/dailywd/api/|jq -r .txt |xargs echo
  #一言 https://hitokoto.cn/api
}

# 产生随机一首诗词
random_poetry(){
   curl -s -H 'X-User-Token:RgU1rBKtLym/MhhYIXs42WNoqLyZeXY3EkAcDNrcfKkzj8ILIsAP1Hx0NGhdOO1I' https://v2.jinrishici.com/sentence|jq .data.origin|xargs echo
}

# 执行函数 [Any]<-(function_name:String,function_parameters:List<Any>)
execute(){
  function_name=$1
  shift # 参数列表以空格为分割左移一位,相当于丢弃掉第一个参数
  function_parameters=$*
  (${function_name} "${function_parameters}")
}
