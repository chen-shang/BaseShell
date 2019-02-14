#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2034
if [[ "${BASE_CONSTANT_IMPORTED}" != "0" ]]; then
  BASE_CONSTANT_IMPORTED=0
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
  #因为文件描述符的个数在系统中是有限的,默认最多开1024个,使用这么多的线程池是不合理的
  #这里定义的是系统全局变量,任何地方都可以用到这个值
  #当前进程使用到了那个文件描述符的下标
  LATEST_FD_INDEX=3
fi

function available_fd(){
  [[ $((LATEST_FD_INDEX++)) -eq 255 ]] && log_fail "In the process of a largest open file descriptors is 255" || return ${LATEST_FD_INDEX}
}