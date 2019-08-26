#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
# @attention 注意 1>&2 每一个日志输入都把标准输出重定向到了标准错误输出,目的是在使用log_的时候不影响函数的返回结果
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../config.sh
source ./../../BaseShell/Lang/BaseString.sh

if [[ ! -d ${LOG_DIR} ]]; then mkdir -p "${LOG_DIR}" ;fi

# ERROR<WARN<INFO<DEBUG
case ${LOG_LEVEL} in
   "ERROR" ) log_level=0 ;;
   "WARN"  ) log_level=1 ;;
   "INFO"  ) log_level=2 ;;
   "DEBUG" ) log_level=3 ;;
   "SYSTEM") log_level=4 ;;
esac

# 默认关闭,debug级别的日志会忽略
# debug级别的日志 []<-(msg:String)
function log_debug(){
  if [[ ${log_level} -ge 3 ]];then
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [DEBUG]:   $*"|trim 1>&2
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [DEBUG]:   $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).debug.log" 2>&1
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [DEBUG]:   $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
  fi
}

# info级别的日志 []<-(msg:String)
function log_info(){
  if [[ ${log_level} -ge 2 ]];then
    echo -e "\\033[37m[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [INFO]:    $*\\033[0m"|trim 1>&2
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [INFO]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).info.log"  2>&1
    echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [INFO]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log"  2>&1
  fi
}

# warn级别的日志 []<-(msg:String)
function log_warn(){
  if [[ ${log_level} -ge 2 ]];then
    echo -e "\033[33m[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [WARN]:    $*\033[0m"|trim 1>&2
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [WARN]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).info.log" 2>&1
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [WARN]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
  fi
}

# error级别的日志 []<-(msg:String)
function log_error(){
  if [[ ${log_level} -ge 0 ]];then
    echo -e "\\033[31m[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [ERROR]:   $*\\033[0m"|trim 1>&2
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [ERROR]:   $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).error.log" 2>&1
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [ERROR]:   $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
  fi
}

# 用来标识成功状态的,用绿色 []<-(msg:String)
function log_success(){
  if [[ ${log_level} -ge 2 ]];then
    echo -e "\\033[32m[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [SUCCESS]: $*\\033[0m"|trim 1>&2
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [SUCCESS]: $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).info.log" 2>&1
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [SUCCESS]: $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
  fi
}

# @attention 当前子进程会退出
# 用来标识失败状态的,用红色, []<-(msg:String)
function log_fail(){
  if [[ ${log_level} -ge 2 ]];then
    echo -e "\\033[31m[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [FAIL]:    $*\\033[0m"|trim 1>&2
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [FAIL]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).info.log" 2>&1
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [FAIL]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
    exit 1
  fi
}

# base内部系统级别的日志 []<-(msg:String)
# 一般不用打开,看一眼
function log_system(){
  if [[ ${log_level} -ge 4 ]];then
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [WARN]:    $*"|trim 1>&2
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [WARN]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).info.log" 2>&1
    echo -e "$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [WARN]:    $*"|trim >> "${LOG_DIR}/$(date +%Y-%m-%d).log" 2>&1
  fi
}

# @attention 日志只会输出到日志文件中,不会输出在控制台上,默认开启
# 用来标识追踪日志 []<-(msg:String)
function log_trace(){
  echo -e "[$(date +%Y-%m-%dT%H:%M:%S)][$$ $BASHPID][${FUNCNAME[1]}] [TRACE]:   $*"|trim >>"${LOG_DIR}/$(date +%Y-%m-%d)".trace.log 2>&1
}
