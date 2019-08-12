#!/usr/bin/env bash
#===============================================================
import=$(basename ${BASH_SOURCE} .sh)
if [[ $(eval echo '$'${import}) == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================

source ./../../BaseShell/Lang/BaseObject.sh

function calendar_now() {
   cal
}
