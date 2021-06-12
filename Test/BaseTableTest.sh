#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/File/BaseTable.sh
#===============================================================
table='./table'
test-table_readJson(){
  table_readJson "${table}"
}

#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
