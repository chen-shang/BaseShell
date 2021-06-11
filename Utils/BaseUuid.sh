#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
#===============================================================

# 返回一个uuid [String]<-()
function uuid(){
  uuidgen
}
