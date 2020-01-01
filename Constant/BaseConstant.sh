#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
readonly TRUE=0                         # Linux 中一般0代表真非0代表假
readonly FALSE=1
readonly NONE=''
readonly NULL='null'
readonly PI=3.14159265358979323846
readonly E=2.7182818284590452354