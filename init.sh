#!/usr/bin/env bash
set -u
read -p "project:" project
if [[ -z "${project}"  ]];then
  echo "project can not be null"
  exit
fi
read -p "module:" module
if [[ -z "${module}"  ]];then
  echo "project can not be null"
  exit
fi

# 新建项目目录
mkdir ${project}
cd  ${project}

# 引入BaseShell
BASE_SHELL=$(dirname ${BASH_SOURCE[0]})
ln -s ${BASE_SHELL} ./BaseShell

# 新建模块
mkdir ${module}

cd ${module}
mkdir Resources
mkdir Service
mkdir Test

echo "#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
# 是否显示BANNER
SHOW_BANNER=1
# 日志级别
LOG_LEVEL=DEBUG
" > config.sh

echo "# ${module}
" > readme.md