#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================
#显示方式:0（默认值）、1（高亮）、22（非粗体）、4（下划线）、24（非下划线）、5（闪烁）、25（非闪烁）、7（反显）、27（非反显）
#前景色:30（黑色）、31（红色）、32（绿色）、 33（黄色）、34（蓝色）、35（洋红）、36（青色）、37（白色）
#背景色:40（黑色）、41（红色）、42（绿色）、 43（黄色）、44（蓝色）、45（洋红）、46（青色）、47（白色）
#\033[显示方式;前景色;背景色m   \033[0m

COLOR_CODE_FB_BLACK=30;  COLOR_CODE_BG_BLACK=40;  #黑色
COLOR_CODE_FB_RED=31;    COLOR_CODE_BG_RED=41;    #红色
COLOR_CODE_FB_GREEN=32;  COLOR_CODE_BG_GREEN=42;  #绿色
COLOR_CODE_FB_YELLOW=33; COLOR_CODE_BG_YELLOW=43; #黄色
COLOR_CODE_FB_BLUE=34;   COLOR_CODE_BG_BLUE=44;   #蓝色
COLOR_CODE_FB_MAGENTA=35;COLOR_CODE_BG_MAGENTA=45;#洋红
COLOR_CODE_FB_CYAN=36;   COLOR_CODE_BG_CYAN=46;   #青色
COLOR_CODE_FB_WHITE=37;  COLOR_CODE_BG_WHITE=47;  #白色


COLOR_FLAG_BEGIN="\033[" ; COLOR_FLAG_END="\033[0m"

COLOR.show(){
  local fg=$1 #前景色
  local bg=$2 #背景色
  shift;shift
  local msg=$* #要展示的文本
  echo -e "${COLOR_FLAG_BEGIN}0;${fg};${bg}m${msg}${COLOR_FLAG_END}"
}

COLOR_BLACK.show(){
  echo -e "${COLOR_FLAG_BEGIN}${COLOR_CODE_BG_BLACK}m$*${COLOR_FLAG_END}"
}
COLOR_RED.show(){
  echo -e "${COLOR_FLAG_BEGIN}${COLOR_CODE_BG_RED}m$*${COLOR_FLAG_END}"
}
COLOR_GREEN.show(){
  echo -e "${COLOR_FLAG_BEGIN}${COLOR_CODE_BG_GREEN}m$*${COLOR_FLAG_END}"
}
COLOR_YELLOW.show(){
  echo -e "${COLOR_FLAG_BEGIN}${COLOR_CODE_BG_YELLOW}m$*${COLOR_FLAG_END}"
}
COLOR_BLUE.show(){
  echo -e "${COLOR_FLAG_BEGIN}${COLOR_CODE_BG_BLUE}m$*${COLOR_FLAG_END}"
}
COLOR_MAGENTA.show(){
  echo -e "${COLOR_FLAG_BEGIN}${COLOR_CODE_BG_MAGENTA}m$*${COLOR_FLAG_END}"
}
COLOR_CYAN.show(){
  echo -e "${COLOR_FLAG_BEGIN}${COLOR_CODE_BG_CYAN}m$*${COLOR_FLAG_END}"
}
COLOR_WHITE.show(){
  echo -e "${COLOR_FLAG_BEGIN}${COLOR_CODE_BG_WHITE}m$*${COLOR_FLAG_END}"
}
