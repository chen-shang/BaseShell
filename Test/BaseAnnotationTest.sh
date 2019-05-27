#!/usr/bin/env bash
# shellcheck disable=SC1091
#################引入需要测试的脚本################
source ./../../BaseShell/Annotation/BaseAnnotation.sh
###################下面写单元测试#################

f1(){
  _NotNull "$1" "param1 can not be null"
  echo "ok"
}

f2(){
  _NotNull "$2" "param2 can not be null"
  echo "ok"
}

f3(){
  _NotNull "$1" "param1 can not be null" && _Numeric "$1" "param1 nust be xxx" && _NotNull "$2" "param2 can not be null" && _Min "1" "$2" && _Max "10" "$2"
  echo "ok"
}

f4(){
  _NotNull "$1" "param1 can not be null"
  echo "ok"
}

f5(){
  _NotNull "$2" "param2 can not be null"
  echo "ok"
}

f6(){
  _NotNull "$1" "param1 can not be null" && _Numeric "$1" "param1 nust be xxx" && _NotNull "$2" "param2 can not be null" && _Min "1" "$2" && _Max "10" "$2"
  echo "ok"
}

test-_NotNull(){
  local result=$(f1 "param1")
  assertEquals "${result}" "ok"
  local result=$(f2 "" "param2")
  assertEquals "${result}" "ok"

  (f3 "1" "param2")      # parameter must be numeric
  (f1 "")                # param1 can not be null
  (f2 "param1" "")       # param2 can not be null
  (f3 "123" "31")        # max value is 10

  (f6 "1" "param2")      # parameter must be numeric
  (f4 "")                # param1 can not be null
  (f5 "param1" "")       # param2 can not be null
  (f6 "123" "31")        # max value is 10
}


###################上面写单元测试#################
source ./../../BaseShell/Utils/BaseTestUtil.sh