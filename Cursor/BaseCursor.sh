#!/usr/bin/env bash
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
#===============================================================

# 定义一个变量记录光标所在位置
eval "cursor_no_$$=1"
# 获取光标所在位置计数
function cursor_no(){
  local cursor_no="cursor_no_$$"
  eval echo '$'"{${cursor_no}}"
}
# 获取光标所在位置计数+1 []<-()
function cursor_no_incr(){
  local cursor_no="cursor_no_$$"
  eval cursor_no_$$='$'"((${cursor_no}+1))"
}
# 获取光标所在位置计数-1 []<-()
function cursor_no_decr(){
  local cursor_no="cursor_no_$$"
  eval cursor_no_$$='$'"((${cursor_no}-1))"
}
#控制光标上移 []<-(line:Integer)
function cursor_up(){
  local line=${1:-1}
  tput cuu "${line}"
}
#控制光标下移 []<-(line:Integer)
function cursor_down(){
  local line=${1:-1}
  tput cud "${line}"
}
#控制光标左移 []<-(line:Integer)
function cursor_left(){
  local line=${1:-1}
  tput cub "${line}"
}
#控制光标右移 []<-(line:Integer)
function cursor_right(){
  local line=${1:-1}
  tput cuf "${line}"
}
