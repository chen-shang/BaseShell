#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Lang/BaseString.sh
source ./../../BaseShell/Collection/BaseArrayList.sh

assertTotalCount=0 #断言总次数
assertFailCount=0 #断言失败次数
assertSuccessCount=0 #断言命中次数

# 断言相等
function assertEquals(){
  assertTotalCount=$((assertTotalCount+1))

  # 结果校验
  local sourceValue=$1 #测试结果
  local targetValue=$2 #预期结果
  local description=$3 #描述
  local result=$(string_equals "${sourceValue}" "${targetValue}")

  test_checkResult "${result}" "${sourceValue}" "${targetValue}" "${description}"
}

# 断言为真
function assertTrue(){
  assertTotalCount=$((assertTotalCount+1))

  # 结果校验
  local sourceValue=$1 #测试结果
  local description=$2 #描述
  local result=$(string_equals "${sourceValue}" "${TRUE}")

  test_checkResult "${result}" "${sourceValue}" "TRUE" "${description}"
}


# 断言为假
function assertFalse(){
  assertTotalCount=$((assertTotalCount+1))

  # 结果校验
  local sourceValue=$1 #测试结果
  local description=$2 #描述
  local result=$(string_equals "${sourceValue}" "${FALSE}")

  test_checkResult "${result}" "${sourceValue}" "FALSE" "${description}"
}

# 检查是否命中结果,并给出相应的日志
test_checkResult(){
  local result=$1 #是否命中结果

  local sourceValue=$2 #测试结果
  local targetValue=$3 #预期结果
  local description=$4 #描述
  # 测试统计
  if [[ ${result} -eq ${TRUE} ]]; then
    assertSuccessCount=$((assertSuccessCount+1))
    log_success "${description} test ok[100%],hit ${targetValue}"
  else
    assertFailCount=$((assertFailCount+1))
    log_fail "${description} test fail[100%],expect ${targetValue} but ${sourceValue}"
  fi
}

# 取出测试文件中待测试的方法
test_getMethodList(){
  # "test-"开头的方法
  # 不被#ignore注释的
  cat <"$0" | grep "test-"      \
            | grep -v "grep"    \
            | grep -v "#ignore" \
            | sed "s/(){//g"
}

# 测试函数执行函数
test_run(){
  local methodList=("$(test_getMethodList)")
  for method in ${methodList[*]}; do
    log_info "开始执行测试函数==============》${method}《=============="
    ${method}
  done

  echo "
   测试方法[$(list_size "${methodList[*]}")]个
   执行断言[${assertTotalCount}]个
   成功:${assertSuccessCount}
   失败:${assertFailCount}
  "
}

# 测试函数执行入口
test_run