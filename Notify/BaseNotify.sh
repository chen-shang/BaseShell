#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
# @attention 注意 1>&2 每一个日志输入都把标准输出重定向到了标准错误输出,目的是在使用log_的时候不影响函数的返回结果
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================
# 仅支持mac系统
# 消息通知 [Void]<-(title:String,message:String)
function notify_send() {
  local title=$1
  local message=$2
  terminal-notifier -title "${title}" -message "${message}" -sound default
}

# 消息通知 [Void]<-(message:String)
function notify_send_msg() {
  local message=$1
  terminal-notifier -title "标题" -message "${message}" -sound default
}

