#!/usr/bin/env bash
project=$1
if [[ -z "${project}" ]];then
  read -r -p "project[项目目录]:" project
fi

set -u
if [[ -z "${project}" ]];then
  echo "project can not be null"
  exit
fi

read -r -p "module[模块名称]:" module
if [[ -z "${module}" ]];then
  echo "module can not be null"
  exit
fi

# 新建项目目录
[[ ! -d "${project}" ]] && mkdir -p "${project}"
cd "${project}" || exit

# 引入BaseShell
BASE_SHELL=$(dirname "${BASH_SOURCE[0]}")
#[[ ! -d BaseShell ]] && ln -nsf "${BASE_SHELL}" ./BaseShell
[[ ! -d BaseShell ]] && cp -r "${BASE_SHELL}" ./BaseShell

# 新建模块
[[ ! -d "${module}" ]] && mkdir -p "${module}"
# 进入模块目录
cd "${module}" || exit
# 新建模块目录结构
mkdir -p Resources Controller Service Enum Test Utils Profile/dev Profile/prod
# 写入样板代码
head="#===============================================================
import=\"\$(basename \"\${BASH_SOURCE[0]}\" .sh)_\$\$\"
if [[ \$(eval echo '$'\"\${import}\") == 0 ]]; then return; fi
eval \"\${import}=0\""

# 写入默认的配置文件
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2154,SC2034,SC1090
${head}
#===============================================================
# 日志级别
LOG_LEVEL=DEBUG
" >config.sh

# 写入默认的Controller
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
${head}
#===============================================================
#导入工具包
source ./../../BaseShellMini.sh
source ./../config.sh
#===============================================================================
#业务代码
main(){
  echo \"hello world\"
}
#===============================================================================
main
" >"./Controller/Main.sh"

# 写入默认的Controller
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
${head}
#===============================================================
#导入工具包
source ./../../BaseShellMini.sh
source ./../config.sh
#===============================================================================
#业务代码
demo(){
  echo \"Ok\"
}
" >"./Service/MainService.sh"

# 写入默认的Test
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShellMini.sh
source ./../config.sh
#===============================================================
# 引入测试脚本
source ./../Service/MainService.sh
#===============================================================
# 编写测试用例
test-demo(){
  local result=\$(demo)
  assertEquals \"\${result}\" \"ok\"
}
#===============================================================
" >"./Test/DemoServiceTest.sh"

tree "./../../${project}"
