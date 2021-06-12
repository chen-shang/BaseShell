#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Log/BaseLog.sh
#===============================================================
test-log(){
  log_info     "$(echo "{\"one\":1}"|jq .)"
  log_debug    "$(echo "{\"one\":1}"|jq .)"
  log_error    "$(echo "{\"one\":1}"|jq .)"
  log_success  "$(echo "{\"one\":1}"|jq .)"
  log_warn     "$(echo "{\"one\":1}"|jq .)"
  log_trace    "$(echo "{\"one\":1}"|jq .)"
  log_info     "$(echo "{\"one\":1}"|jq .)"
  test-lineNo
  log_fail     "$(echo "{\"one\":1}"|jq .)"
  log_info     "$(echo "{\"one\":1}"|jq .)"
}

test-lineNo(){ #ignore
  log_info   "$(echo "{\"one\":222}"|jq .)"  
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
