#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
source ./../../BaseShell/Utils/BaseUuid.sh
#===============================================================================
new_lock(){
  local lock=$1

  isBlank "${lock}" && {
    new_FIFO ; lock=$?
  }

  new_FD_FIFO "${lock}"
  echo 0 >& "${lock}"

  log_debug "lock FD:${lock}"
  return ${lock}
}

lock_tryLock(){ _NotBlank "$1" "lock fd can not be null"
  read -r -u "$1"
}

lock_unLock(){ _NotBlank "$1" "lock fd can not be null"
  echo 0 >& "$1"
}