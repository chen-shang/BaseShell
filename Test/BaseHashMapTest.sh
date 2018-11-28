#!/usr/bin/env bash

# shellcheck disable=SC1091
#################引入需要测试的脚本################
source ./../../BashShell/Collection/BaseHashMap.sh
###################下面写单元测试#################

test-map_put(){
  map=($(new_hashMap))
  map=($(map_put "${map[*]}" "one" "1"))
  map=($(map_put "${map[*]}" "two" "1"))
  map=($(map_put "${map[*]}" "three" "1"))
  echo ${map[*]}
}
###################上面写单元测试#################
source ./../../BashShell/Utils/BaseTestUtil.sh