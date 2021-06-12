#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
# Header 的引入是为了引进每个脚本都公共的函数、常量等
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/config.sh
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/UnitTest/BaseTest.sh
#===============================================================

# 加载自定义配置
if [[ -f ./../config.sh ]];then
  source ./../config.sh
fi

# 显示 Banner 图
if [[ ${SHOW_BANNER} == 0 ]] && [[ -f "${BANNER_PATH}" ]];then
  cat < "${BANNER_PATH}" |lolcat
fi
