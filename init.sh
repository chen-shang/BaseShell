#!/usr/bin/env bash
set -u

read -p "project[项目目录]:" project
if [[ -z "${project}"  ]];then
  echo "project can not be null"
  exit
fi

read -p "module[模块名称]:" module
if [[ -z "${module}"  ]];then
  echo "module can not be null"
  exit
fi

# 新建项目目录
mkdir -p "${project}"
cd  "${project}" || exit

# 引入BaseShell
BASE_SHELL=$(dirname ${BASH_SOURCE[0]})
#ln -nsf "${BASE_SHELL}" ./BaseShell
cp -r "${BASE_SHELL}" ./BaseShell

# 新建模块
mkdir -p "${module}"
cd "${module}" || exit

mkdir -p Resources Controller Service Test Utils Profile/dev Profile/prod

head="#===============================================================
import=\"\$(basename \"\${BASH_SOURCE[0]}\" .sh)_\$\$\"
if [[ \$(eval echo '$'\"\${import}\") == 0 ]]; then return; fi
eval \"\${import}=0\""

# 写入默认的配置文件
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2154,SC2034,SC1090
${head}
#===============================================================
ENV=dev
[ -f ./../Profile/\${ENV}/application.sh ] && source \"./../Profile/\${ENV}/application.sh\"
#默认dev
[ -f ./Profile/dev/application.sh ] && source \"./Profile/dev/application.sh\"
#===============================================================
# 是否显示BANNER
SHOW_BANNER=0
# 日志级别
LOG_LEVEL=DEBUG
" > config.sh

# 写入默认的readme文件
echo "# ${module}
" > readme.md

# 写入默认的Controller
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
${head}
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
source ./../config.sh
#导入工具包
#===============================================================================
#业务代码
main(){
  echo \"hello world\"
}
#===============================================================================
source ../../BaseShell/Starter/BaseEnd.sh
" > "./Controller/Main.sh"

# 写入默认的Service
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
${head}
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
source ./../config.sh
#导入工具包
#===============================================================================
#业务代码
function demo(){
  echo \"ok\"
}
" > "./Service/DemoService.sh"

# 写入默认的Test
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
# 引入测试脚本
source ./../Service/DemoService.sh
#===============================================================
# 编写测试用例
test-demo(){
  local result=\$(demo)
  assertEquals \"\${result}\" \"ok\"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
" > "./Test/DemoServiceTest.sh"

# 写入默认的application.sh
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2154,SC2034
${head}
#===============================================================
readonly _author_=$(whoami)
" > "./Profile/dev/application.sh"
cp "./Profile/dev/application.sh" "./Profile/prod/application.sh"

tree "./../../${project}"
