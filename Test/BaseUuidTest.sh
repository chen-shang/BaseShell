#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Utils/BaseUuid.sh
#===============================================================
test-uuid(){
  local uuid=$(uuid)
  assertNotNull "${uuid}"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
