#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Lang/BaseObject.sh
source ./../../BaseShell/Log/BaseLog.sh

# 判断传入参数是否为空 [Boolean]<-(param:String,err_msg:String)
function _NotNull(){
  local param=$1;local err_msg=$2
  err_msg=${err_msg:-'parameter can not be null'}
  [[ -z "${param}" ]] && log_fail "${err_msg}" || return "${TRUE}"
}

# 判断传入参数是否为自然数 [Boolean]<-(param:String,err_msg:String)
function _Natural(){
  local param=$1;local err_msg=$2
  err_msg=${err_msg:-'parameter must be numeric'}
  ! grep -q '^[[:digit:]]*$' <<< "${param}" && log_fail "${err_msg}" ||  return "${TRUE}"
}

# @param $1:最小值 $2:参数值 $3:err_msg
# 判断传入参数是否大于 [Boolean]<-(Number,Number,String)
function _Min(){ _NotNull "$1" ; _NotNull "$2"
  local err_msg=$3
  err_msg=${err_msg:-"value can not be less than $1"}
  # $2:参数值 < $1:最小值
  # 注意bc计算器0代表假，1代表真
  [[ $(echo "$2 < $1" | bc) -eq 1 ]] && log_fail "${err_msg}" || return "${TRUE}"
}

# @param $1:最小值 $2:参数值 $3:err_msg
# 判断传入参数是否小于 [Boolean]<-(Number,Number,String)
function _Max(){ _NotNull "$1" ; _NotNull "$2"
  local err_msg=$3
  err_msg=${err_msg:-"value can not be bigger than  $1"}
  # $2:参数值 > $1:最小值
  # 注意bc计算器0代表假，1代表真
  [[ $(echo "$2 > $1" | bc) -eq 1 ]] && log_fail "${err_msg}" || return "${TRUE}"
}
