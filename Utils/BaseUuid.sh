#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import="$(basename "${BASH_SOURCE[0]}" .sh)_$$"
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
#导入工具包
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================

# 返回一个uuid [String]<-()
function uuid(){
  uuidgen
}
