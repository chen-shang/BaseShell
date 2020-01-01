#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/File/BaseTable.sh
#===============================================================
table='./table'
test-csv_read(){
  csv=$(csv_read "${table}")
  echo "${csv}"
}

test-csv_header(){
  csv=$(csv_read "${table}")
  echo "${csv}"|csv_header
  csv_header "${table}"
  csv_header "${csv}"
}

test-csv_readLine(){
  csv_readLine "${table}" "1"
  csv_readLine "${table}" "0"
}

test-csv_readColumn(){
  csv_readColumn "${table}" "1"
  csv_readColumn "${table}" "id"
}

#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
