#!/usr/bin/env bash
# shellcheck disable=SC1091
source ./../../BaseShell/Utils/BaseHeader.sh

# 返回一个uuid [String]<-()
function uuid_randomUUID(){
  uuidgen
}