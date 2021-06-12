#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
# 这段的作用是为了判断当前Mini脚本是否之前被引用过
IMPORT_SHELL_FLAG="${BASH_SOURCE[0]////_}"   #导入的脚本名称,把所有的/替换成_
IMPORT_SHELL_FLAG="${IMPORT_SHELL_FLAG//./_}" #导入的脚本名称,把所有的.替换成_
if [[ $(eval echo '$'"${IMPORT_SHELL_FLAG}") == 0 ]]; then return; fi 
eval "${IMPORT_SHELL_FLAG}=0";
#===============================================================
# 加载自定义配置
if [[ -f ./../config.sh ]];then
  source ./../config.sh
fi

# 显示 Banner 图
if [[ ${SHOW_BANNER} == 0 ]] && [[ -f "${BANNER_PATH}" ]] ;then
  cat < "${BANNER_PATH}" |lolcat
fi
#===============================================================
# 默认引入的常用工具函数
# 脚本中被 #ignore 修饰的不自动生成文档
# 脚本使用帮助文档
function manual(){ #ignore
  cat <"$0"                  |
      grep -v '#ignore'      |
      grep -B1 'function'    |
      grep -EB1 '(){|() {}'  |
      grep -v "\\--"         |
      sed "s/function //g"   |
      sed "s/(){//g"         |
      sed "s/() {//g"        |
      sed 'N;s/\n/ /'        |
      grep '#'               |
      sed "s/#//g"           |
      awk '{print $1,$3,$2}' |
      column -t
}

# 函数的详细描述
function desc(){ _NotBlank "$1" "function can not be null" #ignore
  local func=$1
  local begin=$(cat <"$0"|grep -n -B10 "${func}(){"|grep -w "}"|tail -1|awk -F '-' '{print $1}')
  local end=$(cat <"$0"|grep -n "${func}(){"|tail -1|awk -F ':' '{print $1}')
  sed -n "$((begin+1)),${end}p" "$0"
}

#==========================BaseConstant.sh=====================================
readonly TRUE=0                         # Linux 中一般0代表真非0代表假
readonly FALSE=1
readonly NONE=''
readonly NULL='null'
readonly PI=3.14159265358979323846
readonly E=2.7182818284590452354

#==========================Object=====================================
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

isTrue(){
  local value1=$* #一参
  equals "${value1}" "${TRUE}"
}

isFalse(){
  local value1=$* #一参
  ! isTrue "${value1}"
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

#==========================String.sh=====================================
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
#==========================Log.sh=====================================
# 日志记录位置
LOG_DIR="/tmp"

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
    exit 127
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
function random_word(){
  #木芽一言 https://api.xygeng.cn/dailywd/?pageNum=320
  curl -s https://api.xygeng.cn/dailywd/api/|jq -r .txt |xargs echo
  #一言 https://hitokoto.cn/api
}

# 产生随机一首诗词
function random_poetry(){
   curl -s -H 'X-User-Token:RgU1rBKtLym/MhhYIXs42WNoqLyZeXY3EkAcDNrcfKkzj8ILIsAP1Hx0NGhdOO1I' https://v2.jinrishici.com/sentence|jq .data.origin|xargs echo
}

#==========================测试相关=====================================

# 断言目标值是
assertEquals(){
  equals "$1" "$2" && log_success "test ok[100%],hit [${2}]"
  equals "$1" "$2" || log_error "test fail[100%],expect [${2}] but [${1}]"
}

# 断言目标值不为空
assertNotNull(){
  isNotBlank "$1" && log_success "test ok[100%],hit [${1}]"
  isNotBlank "$1" || log_error "test fail[100%],expect not null"
}

# 断言目标值为空
assertNull(){
  isBlank "$1" && log_success "test ok[100%],hit [${1}]"
  isBlank "$1" || log_error "test fail[100%],expect null but [${1}]"
}

# 断言目标值为假(非零)
assertFalse(){
  equals "$1" "${FALSE}" && log_success "test ok[100%],hit [FALSE]"
  equals "$1" "${FALSE}" || log_error "test fail[100%],expect false [FALSE] but [TRUE]"
}

# 断言目标值为真(为零)
assertTrue(){
  equals "$1" "${TRUE}" && log_success "test ok[100%],hit [TRUE]"
  equals "$1" "${TRUE}" || log_error "test fail[100%],expect [TRUE] but [FALSE]"
}

#==========================ssh.sh=====================================
timeout=60
# @param ip   登陆ip地址
# @param port 登陆端口号
# @param port 登陆账号
# @param pass 登陆密码
# 检查机器登陆 [String]<-(ip:String,port:Int,user:String,pass:String)
function ssh_checkLogin(){ _NotBlank "$1" "ip can not be null" && _NotBlank "$2" "port can not be null" && _NotBlank "$3" "user can not bull" && _NotBlank "$4" "pass can not bull"
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4
  local key="ssh ${user}@${ip} -p ${port} [${pass}]"
  expect -c "
    set timeout ${timeout}
    spawn ssh -p ${port} ${user}@${ip} 'pwd'
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*Permission denied*\" {exit 3}
      \"*assword*\" { send \"${pass}\r\";exp_continue }
      \"*Connection closed by remote host*\" { exit 1 }
      \"*Connection refused*\" {exit 2}
      \"*Network is unreachable*\" {exit 4}
      \"*Connection reset by peer*\" {exit 5}
      \"*Protocol major versions differ*\" {exit 6}
      \"*WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!*\" {exit 7}
      \"*setsockopt SO_KEEPALIVE: Invalid argument*\" {exit 8}
      \"*${user}*\" {exit 0}
      timeout {exit 127}
    }
    expect eof
  " >> /dev/null #将expect执行的中间输输出过程忽略

  local status=$?
  case ${status} in
    0)   log_trace "登陆成功 ${key}" ;;
    1)   log_error "连接过多 ${key}" ;;
    2)   log_error "拒绝连接 ${key}" ;;
    3)   log_error "密码错误 ${key}" ;;
    4)   log_error "端口错误 ${key}" ;;
    5)   log_error "sshd 服务异常  ${key}" ;;
    6)   log_error "sshd 版本不一致 ${key}" ;;
    7)   log_error "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! ${key}" ;;
    8)   log_error "setsockopt SO_KEEPALIVE: Invalid argument ${key}" ;;
    127) log_error "登陆超时 ${key}" ;;
    *) log_info "${key} ${status}"
  esac
  return ${status}
}

# @param ip   登陆ip地址
# @param port 登陆端口号
# @param port 登陆账号
# @param pass 登陆密码
# 登陆远程机器 []<-(ip:String,port:Int,pass:String)
function ssh_login(){
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4
  ssh_checkLogin "${ip}" "${port}" "${user}" "${pass}" || return
  expect -c "
    set timeout ${timeout}
    spawn ssh -p ${port} ${user}@${ip}
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*password*\" { send \"${pass}\r\" }
      \"*Connection closed by remote host*\" { exit 1 }
      timeout {exit 2}
    }
    interact
  "
}

# @param ip   登陆ip地址
# @param port 登陆端口号
# @param port 登陆账号
# @param pass 登陆密码
# 执行远程命令 [String]<-(ip:String,port:Int,pass:String,cmd:String)
function ssh_run(){
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4 ;local cmd=$5
  ssh_checkLogin "${ip}" "${port}" "${user}" "${pass}" || return
  expect -c "
    set timeout ${timeout}
    spawn ssh -p ${port} ${user}@${ip} ${cmd};
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*assword*\" { send \"${pass}\r\" }
      \"*Connection closed by remote host*\" { exit 1 }
      timeout {exit 2}
    };
    expect eof;
  "
}

# @param ip   登陆ip地址
# @param port 登陆端口号
# @param port 登陆账号
# @param pass 登陆密码
# 执行远程命令 [String]<-(ip:String,port:Int,pass:String,cmd:String)
function ssh_exec(){
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4 ;local cmd=$5
  expect -c "
    set timeout ${timeout}
    spawn ssh -p ${port} ${user}@${ip} ${cmd};
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*assword*\" { send \"${pass}\r\" }
      \"*Connection closed by remote host*\" { exit 1 }
      timeout {exit 2}
    };
    expect eof;
  "
}

# @param ip   登陆ip地址
# @param port 登陆端口号
# @param pass 登陆密码
# @param file 待上传的文件
# @param dir  上传到远程服务器的目录
# 执行远程命令 [String]<-(ip:String,port:Int,pass:String,file:String,dir:String)
function ssh_upload(){
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4 ;local file=$5 ;local dir=$6
  ssh_checkLogin "${ip}" "${port}" "${user}" "${pass}" || return
  expect -c "
    set timeout 20;
    # 先判断目录存不存在,不存在则新建之
    spawn ssh -p ${port} ${user}@${ip}
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*assword*\" { send \"${pass}\r\" }
      \"*Connection closed by remote host*\" {exit 1}
      timeout {exit 2}
    };
    expect *root@* { send \"\[ -d ${dir} \] && echo exist || mkdir -p ${dir} ; exit \r\"};
    # scp上传文件
    spawn scp -r -P ${port} ${file} ${user}@${ip}:${dir};
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*assword*\" { send \"${pass}\r\" }
    };
    expect eof;
  "
}

#==========================并发相关=====================================
# 该锁利用fifo的阻塞原理实现 非重入锁
# 新建一个锁 []<-(lock_fd:String)
new_lock(){ _NotBlank "$1" "lock fd can not be null"
  local fd=$1
  new_fifo "${fd}"
  echo 0 >& "${fd}"
}

# 尝试加锁,也就是获取fifo的执行令牌,并发情况下只有一个线程可以获取到
# 非冲入锁,切勿连续两次上锁,否则有可能死锁
# 尝试加锁 []<-(lock_fd:String)
lock_tryLock(){ _NotBlank "$1" "lock fd can not be null"
  local fd=$1
  ! isExist "${fd}" && {
    new_lock "${fd}"
  }
  read -r -u "${fd}"
}

# 解锁,也就是归还fifo的执行令牌,并发情况下只有一个线程可以获取到
# 非冲入锁,切勿连续两次解锁,否则有可能死锁
# 解锁 []<-(lock_fd:String)
lock_unLock(){ _NotBlank "$1" "lock fd can not be null"
  local fd=$1
  echo 0 >& "${fd}"
}

function lock_run(){ _NotBlank "$1" "lock fd can not be null" && _NotBlank "$2" "function can not be null"
  local fd=$1;shift ; local task=$*
  lock_tryLock "${fd}"
  eval "${task}"
  lock_unLock "${fd}"
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

#==========================Thread.sh=====================================
# 该线程池的实现方法与下面的 BaseThreadPoolExecutor.sh 实现不同。与Java中的线程池实现不同
# 实现方式令牌队列中存放指定执行个数的令牌,令牌队列为空的时候阻塞任务的提交
# 令牌队列不为空的时候允许拿走一个令牌执行
# 该令牌队列保证了:在多线程环境下获取令牌是互斥的,利用fifo的阻塞和read命令一次读取一行

# coreSize:核心线程数
# eg: new_threadPool && local pool=$?
# 新建线程池 [int]<-(coreSize:Integer)
new_threadPool(){ _NotBlank "$1" "core size can not be null" && _Natural "$1" && _Min "0" "$1"
  local coreSize=$1
  local fd=$(new_fd)
  new_fifo "${fd}"
  for((i=0;i<coreSize;i++));do
    #写入令牌
    eval "echo ${i} >& ${fd}"
  done
  return "${fd}"
}

# 注意这个方法是阻塞方法
# 提交一个任务 []<-(task:Function)
threadPool_submit(){ _NotBlank "$1" "thread pool can not be null"
  local fd=$1 ;shift ;local task=$*
  #获取执行令牌,获取不到令牌则阻塞,直到有任务结束执行归还令牌
  read -r -u "${fd}" token
  {
    eval "${task}" #开始执行耗时操作
    eval "echo ${token} >& ${fd}" #归还令牌
  } &
}
#===============================================================================
# 该线程池的实现方法与上面的 BaseThreadPool.sh实现不同。该类与Java的ThreadPoolExecutor.sh实现类似
# 可以说是 ThreadPoolExecutor.java 的简版实现。开发过程当中对Java中一些不得已的设计有了深刻的理解


# coreSize:核心线程数
# keepAliveTime:线程的存活时间
# 任务队列使用的是无限的任务队列
# eg: new_ThreadPoolExecutor && local pool=$?
# 新建线程池 [int]<-(coreSize:Integer,keepAliveTime:Long)
new_ThreadPoolExecutor(){ _NotBlank "$1" "core size can not be null" && _Natural "$1" && _Min "0" "$1"
  local coreSize=$1 #核心线程数
  local keepAliveTime=${2:-1} #线程的存活时间

  local lock=$(new_fd)
  new_lock "${lock}"

  local fd=$(new_fd)
  new_fifo "${fd}"

  for((i=0;i<coreSize;i++));do
    {
      while :;do
        trap 'echo you hit Ctrl-C/Ctrl-\, now exiting.....; exit' SIGINT SIGQUIT
        lock_tryLock "${lock}" #这个地方必须加锁,防止read并发读导致task错乱
        read -t "${keepAliveTime}" -r -u "${fd}" task
        lock_unLock "${lock}"
        isBlank "${task}" && exit
        eval "${task}"
      done
    } &
  done

  return "${fd}"
}

executor_run(){
  local fd=$1 ;shift ;local task=$*
  echo "${task}" >& "${fd}"
}
#===============================================================================

# 执行函数 [Any]<-(functionName,functionParameters:List<Any>)
execute(){
  local functionName=$1
  shift # 参数列表以空格为分割左移一位,相当于丢弃掉第一个参数
  local functionParameters=$*
  eval "${functionName} ${functionParameters}"
}
