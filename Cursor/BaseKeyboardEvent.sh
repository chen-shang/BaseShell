#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import="$(basename "${BASH_SOURCE[0]}" .sh)_$$"
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
#导入工具包
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/Cursor/BaseCursor.sh
#===============================================================
function KeyboardEvent_up(){
  cursor_up
}

function KeyboardEvent_down(){
  cursor_down
}

function KeyboardEvent_left(){
  cursor_left
}

function KeyboardEvent_right(){
  cursor_right
}

function KeyboardEvent_enter(){
  exit
}

function KeyboardEvent_delete(){
  cursor_left
  tput el
}

function KeyboardEvent_esc(){
 exit
}

function KeyboardEvent_tab(){ :

}

function KeyboardEvent_insert(){ :

}

function KeyboardEvent_space(){
  printf " "
}

function KeyboardEvent_all(){ :
}