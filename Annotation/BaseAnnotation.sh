#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Constant/BaseConstant.sh
source ./../../BaseShell/Log/BaseLog.sh
#===============================================================

# 判断传入参数是否为空 [Boolean]<-(param:String,err_msg:String)
function _NotNull(){
  local param=$1;local err_msg=$2
  err_msg=${err_msg:-'parameter can not be null'}
  [[ -z "${param}" ]] && log_fail "${err_msg}" || return "${TRUE}"
}

# 判断传入参数是否为数字 [Boolean]<-(param:String,err_msg:String)
function _Numeric(){
  local param=$1;local err_msg=$2
  err_msg=${err_msg:-'parameter must be numeric'}
  ! grep -q '^[[:digit:]]*$' <<< "${param}" && log_fail "${err_msg}" ||  return "${TRUE}"
}

# @param $1:最小值 $2:参数值
# 判断传入参数是否小于 [Boolean]<-(param:String,err_msg:String)
function _Min(){
  local err_msg="min value is $1"
  # $2:参数值 < $1:最小值
  [[ $2 -lt $1 ]] && log_fail "${err_msg}" || return "${TRUE}"
}

# @param $1:最小值 $2:参数值 (,max)
function _Max(){
  local err_msg="max value is $1"
  # $2:参数值 > $1:最小值
  [[ $2 -gt $1 ]] && log_fail "${err_msg}" || return "${TRUE}"
}