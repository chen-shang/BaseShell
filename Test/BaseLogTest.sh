#!/usr/bin/env bash

# shellcheck disable=SC1091
#################引入需要测试的脚本################
source ./../../BashShell/Log/BaseLog.sh
###################下面写单元测试#################

test-log_info(){
  log_info 1
  log_trace 1
}


test-log_warn(){
  log_warn 2
  log_debug 2
  log_info 2
  log_error 2
  log_success 2
  log_fail 2
  LOG_TRACE_MODEL=${TRUE}
  log_trace 2
}

###################上面写单元测试#################
source ./../../BashShell/Utils/BaseTestUtil.sh