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
  tput rc
  exit
}

KeyboardEvent_delete(){ :

}

KeyboardEvent_esc(){ :

}

KeyboardEvent_tab(){ :

}

KeyboardEvent_insert(){ :

}

KeyboardEvent_space(){ :

}
