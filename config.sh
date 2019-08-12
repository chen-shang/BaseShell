#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
BANNER_PATH="./../../BaseShell/Banner"
SHOW_BANNER=0
