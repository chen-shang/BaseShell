#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Lang/BaseObject.sh
source ./../../BaseShell/File/BaseFile.sh

# 将文件内容读进内存
function csv_read(){
  local fileName=$1
  cat "${fileName}" |column -t
}

# 读取指定的列
function csv_readColumn(){  _NotBlank "$1" "file name can not be null" &&  _NotBlank "$2" "column can not be null"
  local fileName=$1
  local column=$2
  ! isNatural "${column}" && {

    column=$(csv_header "${fileName}"\
    |awk '{for(i=1;i<=NF;i++)a[NR,i]=$i}END{for(j=1;j<=NF;j++)for(k=1;k<=NR;k++)printf k==NR?a[k,j] RS:a[k,j] FS}'\
    |grep -wn "${column}"|awk -F ':' '{print $1}')

    isBlank "${column}" && log_error "column not exist"
  }

  awk '{print $'${column}'}' "${fileName}"
}

# 读取指定的列
function csv_readLine(){
  local fileName=$1 ;local line=$2 ;local column=$3
  file_readLine "${fileName}" "$((line+1))" "${column}"
}

function csv_replaceLine(){
  local fileName=$1 ;local line=$2 ;local text=$3
  file_replaceLine "${fileName}" "${line}" "${text}"
}

function csv_readJson(){
  local fileName=$1 #todo
}

# 行列转置
function csv_transpose(){
  local param=$*
  _action(){
    local param=$*
    file_isFile "${param}" && {
      awk '{for(i=1;i<=NF;i++)a[NR,i]=$i}END{for(j=1;j<=NF;j++)for(k=1;k<=NR;k++)printf k==NR?a[k,j] RS:a[k,j] FS}' "$1"|column -t
    } || {
      echo "${param}"|awk '{for(i=1;i<=NF;i++)a[NR,i]=$i}END{for(j=1;j<=NF;j++)for(k=1;k<=NR;k++)printf k==NR?a[k,j] RS:a[k,j] FS}'|column -t
    }
  }
  pip "${param}"
}

# 获取csv的头
function csv_header(){
  local param=$*
  _action(){
    local param=$*
    file_isFile "${param}" && {
      file_readHead "${param}"|column -t
    } || {
      echo "${param}"|head -n 1
    }
  }
  pip "${param}"
}

#function csv_write(){
#
#}

#function csv_writeJson(){
#
#}