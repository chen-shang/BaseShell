#!/usr/bin/env bash
# shellcheck disable=SC1091
#################引入需要测试的脚本################
source ./../../BaseShell/Concurrent/BaseLock.sh
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
source ./../../BaseShell/Utils/BaseTestUtil.sh