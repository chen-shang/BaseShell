#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Concurrent/BaseLock.sh
source ./../../BaseShell/Concurrent/BaseThreadPoolExecutor.sh
#===============================================================
test-executor_run(){
 #创建一个10个线程的线程池
 new_ThreadPoolExecutor 1
 fd=$?

 # 向线程池提交100个任务
 for i in {1..10};do
   executor_run "${fd}" "sleep 2;log_info 1:${i}"
 done


 #创建一个10个线程的线程池
 new_ThreadPoolExecutor 3
 fd=$?

 # 向线程池提交100个任务
 for i in {1..10};do
   executor_run "${fd}" "sleep 2;log_info 2:${i}"
 done

 wait
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
