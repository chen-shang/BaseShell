#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Starter/BaseStarter.sh

# 断言目标值是
assertEquals(){
  equals "$1" "$2" && log_success "test ok[100%],hit [${2}]"
  equals "$1" "$2" || log_error "test fail[100%],expect [${2}] but [${1}]"
}

# 断言目标值不为空
assertNotNull(){
  isNotBlank "$1" && log_success "test ok[100%],hit [${1}]"
  isNotBlank "$1" || log_error "test fail[100%],expect not null"
}

# 断言目标值为空
assertNull(){
  isBlank "$1" && log_success "test ok[100%],hit [${1}]"
  isBlank "$1" || log_error "test fail[100%],expect null but [${1}]"
}

# 断言目标值为假(非零)
assertFalse(){
  equals "$1" "${FALSE}" && log_success "test ok[100%],hit [FALSE]"
  equals "$1" "${FALSE}" || log_error "test fail[100%],expect false [FALSE] but [TRUE]"
}

# 断言目标值为真(为零)
assertTrue(){
  equals "$1" "${TRUE}" && log_success "test ok[100%],hit [TRUE]"
  equals "$1" "${TRUE}" || log_error "test fail[100%],expect [TRUE] but [FALSE]"
}

# 测试函数执行函数
# 取出测试文件中待测试的方法
# "test-"开头的方法
# 不被#ignore注释的
methodList=$(cat <"$0" | grep "test-" | grep -v "grep"  | grep -v "#ignore" | sed "s/(){//g")
for method in ${methodList}; do
  log_info "开始执行测试函数==============》${method}《=============="
  #子线程执行
  eval "(${method})"
done
