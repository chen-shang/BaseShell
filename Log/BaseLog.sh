#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Constant/BaseConstant.sh
source ./../../BaseShell/Date/BaseLocalDate.sh
source ./../../BaseShell/Date/BaseLocalDateTime.sh

LOG_DIR="${HOME}/.baseshell"
if [[ ! -d ${LOG_DIR} ]]; then
  mkdir -p "${LOG_DIR}";
fi
LOG_TRACE_MODEL=${TRUE}

######################################################################
# 注意 1>&2 每一个日志输入都把标准输出重定向到了标准错误输出,目的是在使用log_的时候不影响函数的返回结果

# debug级别的日志 []<-(msg:String)
function log_debug(){
  echo -e "[$(localdatetime_now)][$$ $BASHPID] [DEBUG]:   $*" 1>&2 \
 | tee -a "${LOG_DIR}/$(localdate_now).debug.log" \
 | tee -a "${LOG_DIR}/$(localdate_now).log"
}

# info级别的日志 []<-(msg:String)
function log_info(){
  echo -e "[$(localdatetime_now)][$$ $BASHPID] [INFO]:    $*" 1>&2 \
 | tee -a "${LOG_DIR}/$(localdate_now).info.log" \
 | tee -a "${LOG_DIR}/$(localdate_now).log"
}

# warn级别的日志 []<-(msg:String)
function log_warn(){
  echo -e "[$(localdatetime_now)][$$ $BASHPID]\033[33m [WARN]\033[0m:    $*" 1>&2 \
 | tee -a "${LOG_DIR}/$(localdate_now).info.log" \
 | tee -a "${LOG_DIR}/$(localdate_now).log"
}

# error级别的日志 []<-(msg:String)
function log_error(){
  echo -e "[$(localdatetime_now)][$$ $BASHPID]\\033[31m [ERROR]\\033[0m:   $*" 1>&2 \
 | tee -a "${LOG_DIR}/$(localdate_now).error.log" \
 | tee -a "${LOG_DIR}/$(localdate_now).log"
}

# 用来标识成功状态的,用绿色 []<-(msg:String)
function log_success(){
  echo -e "[$(localdatetime_now)][$$ $BASHPID]\\033[32m [SUCCESS]\\033[0m: $*" 1>&2 \
 | tee -a "${LOG_DIR}/$(localdate_now).info.log" \
 | tee -a "${LOG_DIR}/$(localdate_now).log"
}

# 用来标识失败状态的,用红色 []<-(msg:String)
function log_fail(){
  echo -e "[$(localdatetime_now)][$$ $BASHPID]\\033[31m [FAIL]\\033[0m:    $*" 1>&2 \
 | tee -a "${LOG_DIR}/$(localdate_now).info.log" \
 | tee -a "${LOG_DIR}/$(localdate_now).log"
 exit
}

# 用来追踪日志,日志输出到文件中,不会影响返回值,默认关闭[]<-(msg:String)
function log_trace(){
  if [[ ${LOG_TRACE_MODEL} ]];then
    echo -e "[$(localdatetime_now)][$$ $BASHPID] [TRACE]:   $*" >>${LOG_DIR}/$(localdate_now).trace.log 2>&1
  fi
}
