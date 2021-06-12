#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/Utils/BaseUuid.sh
#===============================================================
test-uuid(){
  local uuid=$(uuid)
  assertNotBlank "${uuid}"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
