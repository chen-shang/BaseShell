#!/usr/bin/env bash
#################引入需要测试的脚本################
source ./../../BashShell/Concurrent/BaseScheduler.sh
###################下面写单元测试#################
scheduler_timer 1 "log_info eval $(gdate)"

scheduler_counter 3 "log_info eval $(gdate)"
###################上面写单元测试#################
source ./../../BashShell/Utils/BaseTestUtil.sh