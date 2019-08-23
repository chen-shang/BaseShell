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
cd  "${project}"

# 引入BaseShell
BASE_SHELL=$(dirname ${BASH_SOURCE[0]})
ln -nsf "${BASE_SHELL}" ./BaseShell

# 新建模块
mkdir -p "${module}"
cd "${module}"

mkdir -p Resources Service Test

# 写入默认的配置文件
echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
# 是否显示BANNER
SHOW_BANNER=0
# 日志级别
LOG_LEVEL=DEBUG
" > config.sh

# 写入默认的readme文件
echo "# ${module}" > readme.md

echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=\$(basename \"\${BASH_SOURCE[0]}\" .sh)
if [[ \$(eval echo '$'\"\${import}\") == 0 ]]; then return; fi
eval \"\${import}=0\"
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
source ./../config.sh
#导入工具包
#===============================================================================
#业务代码
main(){
  manual
}
#===============================================================================
source ../../BaseShell/Starter/BaseEnd.sh
" > "./Service/${module}Service.sh"

tree "./../../${project}"