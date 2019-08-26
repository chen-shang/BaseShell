#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Concurrent/BaseLock.sh
source ./../../BaseShell/Concurrent/BaseThreadPoolExecutor.sh
#===============================================================
test-lock_tryLock(){
 #创建一个10个线程的线程池
# new_ThreadPoolExecutor 10 1
# local executor=$?

 fd=$(new_fd)
 new_fifo ${fd}

 # 向线程池提交100个任务
 for i in {1..10};do
   executor_run ${fd} "sleep 2;log_info ${i}"
 done

 for((i=0;i<10;i++));do
    {
      while :;do
        trap 'echo you hit Ctrl-C/Ctrl-\, now exiting.....; exit' SIGINT SIGQUIT
        read -t 1 -u ${fd} result
        log_debug "${result}"
        isBlank "${result}" && exit
        eval "${result}"
      done
    } &
  done

 wait
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
