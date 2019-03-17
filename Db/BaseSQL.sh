#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseHeader.sh
#===============================================================================
db_insert(){
  echo 
}

db_select(){
  echo  1
}

db_update(){
  echo
}

db_delete(){
  echo
}

db_create(){
  echo "$*" > user
}

db_drop(){
  echo
}

function db_run(){
  local type=$(echo "$*" |awk '{print $1}')
  case "${type}" in
    "select");;
    "insert");;
    "update");;
    "delete");;
    "drop");;
    "create");;
    *)
      log_error "wrong shell query language"
    ;;
  esac
}
