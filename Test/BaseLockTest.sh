#!/usr/bin/env bash
#################引入需要测试的脚本################
source ./../../BashShell/Concurrent/BaseLock.sh
###################下面写单元测试#################

action(){
  sleep 2
  log_info "action"
}

flock=$(new_flock)
for i in {1..5} ; do
  flcok_action "${flock}" "action" &
done

wait


###################上面写单元测试#################
source ./../../BashShell/Utils/BaseTestUtil.sh