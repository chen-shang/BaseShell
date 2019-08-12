#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename ${BASH_SOURCE} .sh)
if [[ $(eval echo '$'${import}) == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================

source ./../../BaseShell/Utils/BaseHeader.sh
#===============================================================================
