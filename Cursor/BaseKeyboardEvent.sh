#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import="$(basename "${BASH_SOURCE[0]}" .sh)_$$"
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Cursor/BaseCursor.sh
#===============================================================
KeyboardEvent_up(){
  cursor_up
}

KeyboardEvent_down(){
  cursor_down
}

KeyboardEvent_left(){
  cursor_left
}

KeyboardEvent_right(){
  cursor_right
}

KeyboardEvent_enter(){
  exit
}

KeyboardEvent_delete(){
  cursor_left
  tput el
}

KeyboardEvent_esc(){
 exit
}

KeyboardEvent_tab(){ :

}

KeyboardEvent_insert(){ :

}

KeyboardEvent_space(){
  printf " "
}

KeyboardEvent_all(){ :
}
