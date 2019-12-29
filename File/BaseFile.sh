#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#导入工具包
#===============================================================================
# sed -n '1,1p' $1
# 读取第一行 [String]<-(fileName:String)
function file_readHead(){ _NotBlank "$1" "file name can not be null"
  head -n 1 $1
}

# awk 'END {print}' $1
# 读取最后一行 [String]<-(fileName:String)
function file_readTail(){ _NotBlank "$1" "file name can not be null"
  tail -n 1 $1
}

# 读取指定的行,列 [String]<-(fileName:String,line:Long,column:?Long)
function file_readLine(){ _NotBlank "$1" "file name can not be null" &&  _NotBlank "$2" "line name can not be null"
  local fileName=$1 ;local line=$2 ;local column=$3
  isBlank "${column}" && {
    sed -n "${line}p" "${fileName}"
  } || {
    # 将每一个列都加上一个$,然后用逗号分隔,去掉最后的逗号
    local c=$(echo "${column}"|awk -F ',' '{for (i=1;i<=NF;i++)printf("$%s,", $i)}'|string_tailRemove)
    sed -n "${line}p" "${fileName}" |awk '{print '${c}'}'
  }
}

# 获取文件的名称
function file_getName(){ _NotBlank "$1" "file name can not be null"
  basename $1
}

# 获取文件的路径
function file_getPath(){ _NotBlank "$1" "file name can not be null"
  dirname $1
}

# 获取文件一共有多少行
function file_getLines(){ _NotBlank "$1" "file name can not be null"
  cat "$1" |wc -l |xargs echo
}

# 获取文件一共有多少行
function file_getSize(){ _NotBlank "$1" "file name can not be null"
  cat "$1" |wc -c |xargs echo
}
# 获取文件一共有多少行
function file_getSize(){ _NotBlank "$1" "file name can not be null"
  cat "$1" |wc -c |xargs echo
}

function file_canExecute(){
  [[ -x $1 ]]
}

function file_isFile(){ _NotBlank "$1" "file name can not be null"
  [[ -f $1 ]]
}

function file_isExist(){ _NotBlank "$1" "file name can not be null"
  [[ -f $1 ]]
}

function file_isDir(){ _NotBlank "$1" "file name can not be null"
  [[ -d $1 ]]
}

function file_canRead(){ _NotBlank "$1" "file name can not be null"
  [[ -r $1 ]]
}

function file_canWrite(){ _NotBlank "$1" "file name can not be null"
  [[ -w $1 ]]
}

function file_replaceLine(){ _NotBlank "$1" "file name can not be null" && _NotBlank "$2" "line can not be null" && _NotBlank "$3" "text can not be null"
  local fileName=$1 ;local line=$2 ;local text=$3
  sed -i '' "${line}s/.*$/${text}/" ${fileName}
}