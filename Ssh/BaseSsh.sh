#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================

timeout=60
# @param ip   登陆ip地址
# @param port 登陆端口号
# @param port 登陆账号
# @param pass 登陆密码
# 检查机器登陆 [String]<-(ip:String,port:Int,user:String,pass:String)
function ssh_checkLogin(){ _NotBlank "$1" "ip can not be null" && _NotBlank "$2" "port can not be null" && _NotBlank "$3" "user can not bull" && _NotBlank "$4" "pass can not bull"
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4
  local key="ssh ${user}@${ip} -p ${port} [${pass}]"
  expect -c "
    set timeout ${timeout}
    spawn ssh -p ${port} ${user}@${ip} 'pwd'
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*Permission denied*\" {exit 3}
      \"*assword*\" { send \"${pass}\r\";exp_continue }
      \"*Connection closed by remote host*\" { exit 1 }
      \"*Connection refused*\" {exit 2}
      \"*Network is unreachable*\" {exit 4}
      \"*Connection reset by peer*\" {exit 5}
      \"*Protocol major versions differ*\" {exit 6}
      \"*WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!*\" {exit 7}
      \"*setsockopt SO_KEEPALIVE: Invalid argument*\" {exit 8}
      \"*${user}*\" {exit 0}
      timeout {exit 127}
    }
    expect eof
  " >> /dev/null #将expect执行的中间输输出过程忽略

  local status=$?
  case ${status} in
    0)   log_trace "登陆成功 ${key}" ;;
    1)   log_error "连接过多 ${key}" ;;
    2)   log_error "拒绝连接 ${key}" ;;
    3)   log_error "密码错误 ${key}" ;;
    4)   log_error "端口错误 ${key}" ;;
    5)   log_error "sshd 服务异常  ${key}" ;;
    6)   log_error "sshd 版本不一致 ${key}" ;;
    7)   log_error "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED! ${key}" ;;
    8)   log_error "setsockopt SO_KEEPALIVE: Invalid argument ${key}" ;;
    127) log_error "登陆超时 ${key}" ;;
    *) log_info "${key} ${status}"
  esac
  return ${status}
}

# @param ip   登陆ip地址
# @param port 登陆端口号
# @param port 登陆账号
# @param pass 登陆密码
# 登陆远程机器 []<-(ip:String,port:Int,pass:String)
function ssh_login(){
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4
  ssh_checkLogin "${ip}" "${port}" "${user}" "${pass}" || return
  expect -c "
    set timeout ${timeout}
    spawn ssh -p ${port} ${user}@${ip}
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*password*\" { send \"${pass}\r\" }
      \"*Connection closed by remote host*\" { exit 1 }
      timeout {exit 2}
    }
    interact
  "
}

# @param ip   登陆ip地址
# @param port 登陆端口号
# @param port 登陆账号
# @param pass 登陆密码
# 执行远程命令 [String]<-(ip:String,port:Int,pass:String,cmd:String)
function ssh_run(){
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4 ;local cmd=$5
  ssh_checkLogin "${ip}" "${port}" "${user}" "${pass}" || return
  expect -c "
    set timeout ${timeout}
    spawn ssh -p ${port} ${user}@${ip} ${cmd};
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*assword*\" { send \"${pass}\r\" }
      \"*Connection closed by remote host*\" { exit 1 }
      timeout {exit 2}
    };
    expect eof;
  "
}

# @param ip   登陆ip地址
# @param port 登陆端口号
# @param port 登陆账号
# @param pass 登陆密码
# 执行远程命令 [String]<-(ip:String,port:Int,pass:String,cmd:String)
function ssh_exec(){
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4 ;local cmd=$5
  expect -c "
    set timeout ${timeout}
    spawn ssh -p ${port} ${user}@${ip} ${cmd};
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*assword*\" { send \"${pass}\r\" }
      \"*Connection closed by remote host*\" { exit 1 }
      timeout {exit 2}
    };
    expect eof;
  "
}

# @param ip   登陆ip地址
# @param port 登陆端口号
# @param pass 登陆密码
# @param file 待上传的文件
# @param dir  上传到远程服务器的目录
# 执行远程命令 [String]<-(ip:String,port:Int,pass:String,file:String,dir:String)
function ssh_upload(){
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4 ;local file=$5 ;local dir=$6
  ssh_checkLogin "${ip}" "${port}" "${user}" "${pass}" || return
  expect -c "
    set timeout 20;
    # 先判断目录存不存在,不存在则新建之
    spawn ssh -p ${port} ${user}@${ip}
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*assword*\" { send \"${pass}\r\" }
      \"*Connection closed by remote host*\" {exit 1}
      timeout {exit 2}
    };
    expect *root@* { send \"\[ -d ${dir} \] && echo exist || mkdir -p ${dir} ; exit \r\"};
    # scp上传文件
    spawn scp -r -P ${port} ${file} ${user}@${ip}:${dir};
    expect {
      \"*yes/no*\"   { send \"yes\r\"; exp_continue }
      \"*assword*\" { send \"${pass}\r\" }
    };
    expect eof;
  "
}
