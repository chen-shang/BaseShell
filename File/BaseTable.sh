#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/File/BaseFile.sh
#===============================================================

# 将文件内容读进内存
function table_read(){ _NotBlank "$1" "file name can not be null"
  local fileName=$1
  file_read "${fileName}"|awk 'NR>1{print $0}'
}

# 获取csv的头
function table_header(){ _NotBlank "$1" "file name can not be null"
  local fileName=$*
  file_header "${fileName}"
}

function tale_line(){ _NotBlank "$1" "line can not be null" && _NotBlank "$2" "file name can not be null"
  local line=$1;local fileName=$2
  file_line "${line}" "${fileName}"
}

function tale_column(){ _NotBlank "$1" "column can not be null" && _NotBlank "$2" "file name can not be null"
  local column=$1;local fileName=$2
  ! isNatural "${column}" && {

    column=$(csv_header "${fileName}"\
    |awk '{for(i=1;i<=NF;i++)a[NR,i]=$i}END{for(j=1;j<=NF;j++)for(k=1;k<=NR;k++)printf k==NR?a[k,j] RS:a[k,j] FS}'\
    |grep -wn "${column}"|awk -F ':' '{print $1}')

    isBlank "${column}" && log_error "column not exist"
  }

  awk '{print $'${column}'}' "${fileName}"
}

function table_readJson(){
  local fileName=$1
  local header=("$(file_header ${fileName})")
  local i=1
  for column in ${header[*]};do
    local query+='"\"'${column}'\":""\""$'${i}'"\","'
    ((i++))
  done
  local result=("$(eval "table_read ${fileName}|awk '{print ${query}}'"|string_tailRemove)")
  for json in ${result[*]};do
    jsons+="{${json}},"
  done
  echo "[$(echo "${jsons}"|string_tailRemove)]"
}