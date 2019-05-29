#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
if [[ "${BASE_UUID_IMPORTED}" == 0 ]]; then
  return
fi
readonly BASE_UUID_IMPORTED=0
#===============================================================
source ./../../BaseShell/Utils/BaseHeader.sh

# 返回一个uuid [String]<-()
function uuid_randomUUID(){
  uuidgen
}