#!/usr/bin/env bash
# shellcheck disable=SC1091
source ./../../BaseShell/Utils/BaseHeader.sh

# @return a uuid. 秒_纳秒_进程Id
function uuid_randomUUID(){
  uuidgen
}