#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2206,SC2155
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
source ./../../BaseShell/Date/BaseTimeUnit.sh
#===============================================================================
function timestamp_now(){
  date +%s
}

function timestamp_now_nano(){
  echo +%s%N
}

function timestamp_toLocaldate(){
  gdate -d "@$1" "${DEFAULT_LOCALDATE_FORMAT}"
}

function timestamp_toLocaltime(){
  gdate -d "@$1" "${DEFAULT_LOCALTIME_FORMAT}"
}

function timestamp_toLocaldatetime(){
  gdate -d "@$1" "${DEFAULT_LOCALDATETIME_FORMAT}"
}

function timestamp_of(){
  date -d "$1" +%s
}