#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Utils/BaseHeader.sh
#===============================================================
main(){
 echo "hello word"
}
#===============================================================
source ./../../BaseShell/Utils/BaseEnd.sh
