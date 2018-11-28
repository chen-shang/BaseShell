#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#################引入需要测试的脚本################
source ./../../BashShell/Collection/BaseBlockingQueue.sh
###################下面写单元测试#################
new_queue 2
queue1=$?
echo queue1:${queue1},size:$(queue_size ${queue1})
echo LOCK_MAP:${LOCK_POOL_MAP[*]},SIZE_MAP:${SIZE_MAP[*]}
queue_add "${queue1}"  "chenshang1" >>/dev/null
queue_add "${queue1}"  "chenshang2" >>/dev/null
queue_take "${queue1}"
queue_take "${queue1}"


echo "==="
new_queue 20
queue1=$?
echo queue1:${queue1},size:$(queue_size ${queue1})
echo LOCK_MAP:${LOCK_POOL_MAP[*]},SIZE_MAP:${SIZE_MAP[*]}
echo "==="
new_queue 1000
queue2=$?
echo queue2:${queue2},size:$(queue_size ${queue2})
echo LOCK_MAP:${LOCK_POOL_MAP[*]},SIZE_MAP:${SIZE_MAP[*]}

###################上面写单元测试#################
source ./../../BashShell/Utils/BaseTestUtil.sh
