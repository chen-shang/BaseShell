#!/usr/bin/env bash
# shellcheck disable=SC1091
# 编码、解码工具
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================
