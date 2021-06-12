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
[[ ! -d BaseShell ]] && ln -nsf "${BASE_SHELL}" ./BaseShell
#[[ ! -d BaseShell ]] && cp -r "${BASE_SHELL}" ./BaseShell
cp "${BASE_SHELL}/BaseShellMini.sh" ./
cp "${BASE_SHELL}/Starter/BaseImported.sh" ./

# 新建模块
[[ ! -d "${module}" ]] && mkdir -p "${module}"
# 进入模块目录
cd "${module}" || exit
# 新建模块目录结构
mkdir -p Resources Controller Service Enum Test Utils Profile/dev Profile/prod
# 写入样板代码
head="#================================导入工具包=======================================
source ./../../BaseImported.sh && return
source ./../../BaseShellMini.sh"

# 写入默认的配置文件
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2154,SC2034,SC1090
IMPORT_SHELL_FLAG=\"\${BASH_SOURCE[0]////_}\" && IMPORT_SHELL_FLAG=\"\${IMPORT_SHELL_FLAG//./_}\"
if [[ \$(eval echo '$'\"\${IMPORT_SHELL_FLAG}\") == 0 ]]; then return; fi
eval \"\${IMPORT_SHELL_FLAG}=0\"
#===============================================================================
ENV=dev
[ -f ./../Profile/\${ENV}/application.sh ] && source \"./../Profile/\${ENV}/application.sh\"
#默认dev
[ -f ./Profile/dev/application.sh ] && source \"./Profile/dev/application.sh\"
#===============================================================================
# BANNER图的位置
# BANNER_PATH=\"./../../BaseShell/Banner\"
# 是否显示BANNER
SHOW_BANNER=0

# 日志记录位置
# LOG_DIR=\"\${HOME}/.baseshell\"
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
#=================================业务代码========================================
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
#=================================业务代码========================================
function demo(){
  echo \"ok\"
}
" > "./Service/DemoService.sh"

# 写入默认的Test
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
${head}
#================================导入待测包=======================================
source ./../Service/DemoService.sh
#=================================测试用例========================================
test-demo(){
  local result=\$(demo)
  assertEquals \"\${result}\" \"ok\"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
" > "./Test/DemoServiceTest.sh"

# 写入默认的application.sh
echo "#!/usr/bin/env bash
#===================================================================================================
# shellcheck disable=SC1091,SC2155,SC2154,SC2034,SC1090
IMPORT_SHELL_FLAG=\"\${BASH_SOURCE[0]////_}\" && IMPORT_SHELL_FLAG=\"\${IMPORT_SHELL_FLAG//./_}\"
if [[ \$(eval echo '$'\"\${IMPORT_SHELL_FLAG}\") == 0 ]]; then return; fi
eval \"\${IMPORT_SHELL_FLAG}=0\"
#===================================================================================================
readonly _author_=$(whoami)
" > "./Profile/dev/application.sh"
cp "./Profile/dev/application.sh" "./Profile/prod/application.sh"

tree "./../../${project}"

