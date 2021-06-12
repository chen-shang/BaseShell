#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/File/BaseTableGen.sh
#===============================================================
test-genDao(){
  genDao './table'
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
