#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/Cursor/BaseCursor.sh
source ./../../BaseShell/Cursor/BaseKeyboardEvent.sh
#===============================================================
function keyboard_select(){ _NotBlank "$1" "selection can not be null"
  local selection=$1
  local max=$(echo "${selection}"|wc -l)
  echo "${selection}"|while read item;do
    echo " ${item}"
  done
  tput cuu ${max}
  tput sc
  echo ">"
  tput rc

  KeyboardEvent_down(){
    tput civis
    if [[ $(cursor_no) -eq ${max}  ]] ;then
      return
    fi
    tput sc
    echo " "
    tput rc
    cursor_down
    tput sc
    echo ">"
    tput rc
    cursor_no_incr
  }

  KeyboardEvent_up(){
    tput civis
    if [[ $(cursor_no) -eq 1  ]] ;then
      return
    fi
    tput sc
    echo " "
    tput rc
    cursor_up
    tput sc
    echo ">"
    tput rc
    cursor_no_decr
  }

  keyboard_escape up down enter
}

# 注册感兴趣的监听键盘事件
# insert:插入键\delete:退格键\up:上箭头\down:下箭头\left:左箭头\right:右箭头
# 键盘逃逸,键盘监听
function keyboard_escape(){
  local keyboardEvents="$*"
  isBlank "${keyboardEvents}" && {
    keyboardEvents="*"
  }
  while :;do
     unset K1 K2 K3
     read -r -s -N1 K1
     read -r -s -N2 -t '0.0001' K2
     read -r -s -N1 -t '0.0001' K3
     local key="${K1}${K2}${K3}"
     log_trace "${key}"
     if [ "$key" = $'\x1b\x4f\x48' ]; then
       key=$'\x1b\x5b\x31\x7e'
     fi

     #Convert the separate end-key to end-key_num_1.
     if [ "$key" = $'\x1b\x4f\x46' ]; then
      key=$'\x1b\x5b\x34\x7e'
     fi

     case "$key" in
       $'\x1b\x5b\x32\x7e')  # Insert
         ( equals "*" "${keyboardEvents}"  || string_contains "${keyboardEvents}" "insert") && {
            KeyboardEvent_insert
          }
       ;;
       $'\177')  # Delete
          ( equals "*" "${keyboardEvents}"  || string_contains "${keyboardEvents}" "delete") && {
            KeyboardEvent_delete
          }
       ;;
       $'\x1b\x5b\x31\x7e')  # Home_key_num_7
#        todo
       ;;
       $'\x1b\x5b\x34\x7e')  # End_key_num_1
#        todo
       ;;
       $'\x1b\x5b\x35\x7e')  # Page_Up
#        todo
       ;;
       $'\x1b\x5b\x36\x7e')  # Page_Down
#        todo
       ;;
       $'\x1b\x5b\x41')  # Up_arrow
         ( equals "*" "${keyboardEvents}"  || string_contains "${keyboardEvents}" "up") && {
            KeyboardEvent_up
         }
       ;;
       $'\x1b\x5b\x42')  # Down_arrow
         ( equals "*" "${keyboardEvents}"  || string_contains "${keyboardEvents}" "down") && {
            KeyboardEvent_down
         }
       ;;
       $'\x1b\x5b\x43')  # Right_arrow
        ( equals "*" "${keyboardEvents}"  ||  string_contains "${keyboardEvents}" "right") && {
            KeyboardEvent_right
         }
       ;;
       $'\x1b\x5b\x44')  # Left_arrow
        ( equals "*" "${keyboardEvents}"  ||  string_contains "${keyboardEvents}" "left") && {
            KeyboardEvent_left
         }
       ;;
       $'\x09')  # Tab
        ( equals "*" "${keyboardEvents}"  ||  string_contains "${keyboardEvents}" "tab") && {
            KeyboardEvent_tab
         }
       ;;
       $'\x0a')  # Enter
         ( equals "*" "${keyboardEvents}"  || string_contains "${keyboardEvents}" "enter") && {
           KeyboardEvent_enter
         }
       ;;
       $'\x1b')  # Escape
         ( equals "*" "${keyboardEvents}"  || string_contains "${keyboardEvents}" "esc") && {
            KeyboardEvent_esc
         }
       ;;
       $'\x20')  # Space
        ( equals "*" "${keyboardEvents}"  || string_contains "${keyboardEvents}" "space") && {
            KeyboardEvent_space
         }
       ;;
       *) # 自定义按键
         equals "*" "${keyboardEvents}"  && {
            KeyboardEvent_all "${key}"
         } || {
            string_contains "${keyboardEvents}" "${key}" && {
              KeyboardEvent_${key}
            }
         }
     esac
  done
}