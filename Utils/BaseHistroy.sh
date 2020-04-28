#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import="$(basename "${BASH_SOURCE[0]}" .sh)_$$"
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseStarter.sh

# 返回一个uuid [String]<-()
function history_list(){
#  HISTFILE=~/.bash_history
#  set -o history
#  history |awk '{print $2,$3,$4}'|sort -u
   cat ~/.bash_history|sort -u|head -10
}
