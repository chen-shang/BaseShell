#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================================
# 断言目标值是
function assertEquals(){
  equals "$1" "$2" && log_success "test ok[100%],hit [${2}]"
  equals "$1" "$2" || log_error "test fail[100%],expect [${2}] but [${1}]"
}

# 断言目标值不为空
function assertNotBlank(){
  isNotBlank "$1" && log_success "test ok[100%],hit [${1}]"
  isNotBlank "$1" || log_error "test fail[100%],expect not null"
}

# 断言目标值为空
function assertBlank(){
  isBlank "$1" && log_success "test ok[100%],hit [${1}]"
  isBlank "$1" || log_error "test fail[100%],expect null but [${1}]"
}

# 断言目标值为假(非零)
function assertFalse(){
  equals "$1" "${FALSE}" && log_success "test ok[100%],hit [FALSE]"
  equals "$1" "${FALSE}" || log_error "test fail[100%],expect false [FALSE] but [TRUE]"
}

# 断言目标值为真(为零)
function assertTrue(){
  equals "$1" "${TRUE}" && log_success "test ok[100%],hit [TRUE]"
  equals "$1" "${TRUE}" || log_error "test fail[100%],expect [TRUE] but [FALSE]"
}
