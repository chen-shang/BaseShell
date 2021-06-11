#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
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