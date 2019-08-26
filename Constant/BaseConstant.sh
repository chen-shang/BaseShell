#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
readonly TRUE=0                         # Linux 中一般0代表真非0代表假
readonly FALSE=1
readonly NONE=''
readonly NULL='null'
readonly EMPTY_LIST='[]'
readonly PI=3.14159265358979323846
readonly E=2.7182818284590452354
readonly NEXT='->'

#这一版本的线程池使用return返回一个文件描述符
#提交任务其实就是向文件描述符注册,文件描述符关联的是一个fifo的有名管道
#可用的文件描述符,也就是说一个进程中最多使用250个文件文件描述符,也就是250个线程池
#因为文件描述符的个数在系统中是有限的,默认最多开`ulimit -n`个,使用这么多的线程池是不合理的
#这里定义的是系统全局变量,任何地方都可以用到这个值
#当前进程使用到了那个文件描述符的下标

# 注意这里本质上还是使用的文件
FIFO=$(uuidgen)
[[ -e "${FIFO}" ]] || mkfifo "${FIFO}" #如果有名管道不存在,则创建一个有名管道当做线程池,利用有名管道作为阻塞队列来调度任务的执行
exec 3<>${FIFO} && rm -rf "${FIFO}"
echo 3 >&3

# 这个方法默认是同步的,相当于Java中加了synchronized
function getNowFd(){
  # 如果多线程竞争最后一个文件描述符,只有一个能执行成功,直到文件描述符再次写入管道
  read -r -u3 nowFd
  echo "${nowFd}" >&3
  echo "${nowFd}"
}

# 这个方法默认是同步的,相当于Java中加了synchronized
# 新建可用的文件描述符
function new_FD(){
  # 如果多线程竞争最后一个文件描述符,只有一个能执行成功,直到+1之后的下一个文件描述符写入管道
  read -r -u3 newFd
  # +1之后立马写回管道
  ((newFd++))
  echo "${newFd}" >&3
  echo "${newFd}"
}

# 注意该方法使用$?取值,一个应用进程中只能使用255个文件描述符
# 新建一个有名管道,返回文件描述符
function new_FIFO(){
  local FD=$(new_FD)
  new_FD_FIFO "${FD}"
  return ${FD}
}

# 新建一个有名管道,返回文件描述符
function new_FD_FIFO(){
  [[ -z "$1" ]] && {
    echo "fd can not be blank"
    exit
  }

  local FD=$1
  # 关联一个fifo有名管道
  local FIFO=$(uuidgen)
  [[ -e "${FIFO}" ]] || mkfifo "${FIFO}"
  eval "exec ${FD}<>${FIFO} && rm -rf ${FIFO}"
}
