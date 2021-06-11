#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================} 
# @param $1:参数值 $2:err_msg
# 判断传入参数是否为空 [Boolean]<-(param:String,err_msg:String)
function _NotBlank(){
  local param=$(echo "$1"|trim);local err_msg=$2
  err_msg=${err_msg:-'parameter can not be null'}
  [[ -z "${param}" ]] && log_fail "${err_msg}" || return ${TRUE}
}

# @param $1:参数值 $2:err_msg
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
