#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Starter/BaseImported.sh && return

#test -n "$(declare -F mock)" && mock
# 测试函数执行函数
# 取出测试文件中待测试的方法
# test-开头的方法
# 不被#ignore注释的
methodList=$(cat <"$0" | grep "test-" |grep -v "grep" |grep -E "(){|() {"| grep -v "#ignore" | sed "s/(){//g")
# 测试文件名
testFile=$(basename "${BASH_SOURCE[1]}" .sh)
for method in ${methodList}; do
  log_info "开始执行测试函数==============》${testFile}:${method}《=============="
  #子线程执行
  eval "(${method})"
done
