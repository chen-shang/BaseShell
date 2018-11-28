#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BashShell/Utils/BaseHeader.sh
# not null
function ^NotNull(){
  local err_msg=$2
  err_msg=${err_msg:-'parameter can not be null'}
  [[ -z "$1" ]] && log_fail "${err_msg}" || return ${TRUE}
}

# is numeric
function ^Numeric(){
  local param=$1
  local err_msg=$2
  err_msg=${err_msg:-'parameter must be numeric'}
  [[ ! $(grep '^[[:digit:]]*$' <<< "${param}") ]] && log_fail "${err_msg}" || return "${TRUE}"
}

# @param $1:最小值 $2:参数值 (min,)
function ^Min(){
  local err_msg="min value is $1"
  # $2:参数值 < $1:最小值
  [[ $2 -lt $1 ]] && log_fail "${err_msg}" || return ${TRUE}
}

# @param $1:最小值 $2:参数值 (,max)
function ^Max(){
  local err_msg="max value is $1"
  # $2:参数值 > $1:最小值
  [[ $2 -gt $1 ]] && log_fail "${err_msg}" || return ${TRUE}
}