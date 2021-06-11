#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
#===============================================================================
# 将文件内容读进内存
function file_read(){ _NotBlank "$1" "file name can not be null"
  local fileName=$1
  cat < "${fileName}"
}
# 支持管道形式 echo ""|file_header
# param: 文件名或文件内容
# 读取第一行 [String]<-(param:String)
function file_header(){
  local param=$*
  _action(){
    local param=$*
    file_isFile "${param}" && {
       cat "${param}"|head -n 1
    } || {
      echo "${param}"|head -n 1
    }
  }
  pip "${param}"
}

# 支持管道形式 echo ""|file_tailer
# param: 文件名或文件内容
# 读取最后一行 [String]<-(param:String)
function file_tailer(){
  local param=$*
  _action(){
    local param=$*
    file_isFile "${param}" && {
      cat "${param}"|tail -n 1
    } || {
      echo "${param}"|tail -n 1
    }
  }
  pip "${param}"

}

# 支持管道形式 echo ""|file_line 1
# line:指定的行数
# file:指定文件名
# 读取指定一行 [String]<-(line:Long,file:String)
function file_line(){ _NotBlank "$1" "line can not be null"
  local line=$1
  local file=$2
  _action(){
    local line=$1
    local file=$2
    file_isFile "${file}" && {
      cat "${file}"|sed -n "${line}p"
    } || {
      echo "${file}"|sed -n "${line}p"
    }
  }
  pip2 "${line}" "${file}"
}

# 支持管道形式  echo ""|file_column 1
# column:指定的列数
# file:指定文件名
# 读取指定一列 [String]<-(column:Long,file:String)
function file_column(){ _NotBlank "$1" "column can not be null"
  local column=$1
  local file=$2
  _action(){
    local column=$1
    local file=$2
    file_isFile "${file}" && {
      awk '{print $'${column}'}' "${file}"
    } || {
      echo -e "${file}"|awk '{print $'${column}'}'
    }
  }
  pip2 "${column}" "${file}"
}

# 支持管道形式  echo -e ""|skip
# skip:跳过指定行数
# 跳过指定行数 [String]<-(skip:Long)
function skip(){ _NotBlank "$1" "skip can not be null"
  local paramStd=$*
  _action(){
    local paramStd=$1
    local paramPip=$2
    echo "${paramPip}"|awk "NR>${paramStd}"
  }
  pip2 "${paramStd}"
}
# 支持管道形式  echo -e ""|offset
# offset:跳过指定行数
# 跳过指定行数 [String]<-(offset:Long)
function offset(){ _NotBlank "$1" "offset can not be null"
  local paramStd=$*
  _action(){
    local paramStd=$1
    local paramPip=$2
    echo "${paramPip}"|awk "NR>${paramStd}"
  }
  pip2 "${paramStd}"
}
# 支持管道形式  echo -e ""|limit
# limit:选取指定行数
# 选取指定行数 [String]<-(limit:Long)
function limit(){ _NotBlank "$1" "limit can not be null"
  local paramStd=$*
  _action(){
    local paramStd=$1
    local paramPip=$2
    echo "${paramPip}"|head -n "${paramStd}"
  }
  pip2 "${paramStd}"
}

# 行列转置
function transpose(){
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

# 获取文件的名称 [String]<-(file:String)
function file_getName(){ _NotBlank "$1" "file name can not be null"
  basename $1
}

# 获取文件的路径 [String]<-(file:String)
function file_getPath(){ _NotBlank "$1" "file name can not be null"
  dirname $1
}

# 获取文件一共有多少行 [String]<-(file:String)
function file_getLines(){ _NotBlank "$1" "file name can not be null"
  cat "$1" |wc -l |xargs echo
}

# 获取文件一共有多少行 [Long]<-(file:String)
function file_getSize(){ _NotBlank "$1" "file name can not be null"
  cat "$1" |wc -c |xargs echo
}

# 是否是可执行文件 [Boolean]<-(file:String)
function file_canExecute(){ _NotBlank "$1" "file name can not be null"
  [[ -x $1 ]]
}

# 是否是可文件 [Boolean]<-(file:String)
function file_isFile(){ _NotBlank "$1" "file name can not be null"
  [[ -f "$1" ]]
}
# 是否存在 [Boolean]<-(file:String)
function file_isExist(){ _NotBlank "$1" "file name can not be null"
  [[ -f $1 ]]
}
# 是否是文件夹 [Boolean]<-(file:String)
function file_isDir(){ _NotBlank "$1" "file name can not be null"
  [[ -d $1 ]]
}
# 是否可读 [Boolean]<-(file:String)
function file_canRead(){ _NotBlank "$1" "file name can not be null"
  [[ -r $1 ]]
}
# 是否可写 [Boolean]<-(file:String)
function file_canWrite(){ _NotBlank "$1" "file name can not be null"
  [[ -w $1 ]]
}
# 替换指定行 [Boolean]<-(file:String)
function file_replaceLine(){ _NotBlank "$1" "file name can not be null" && _NotBlank "$2" "line can not be null" && _NotBlank "$3" "text can not be null"
  local fileName=$1 ;local line=$2 ;local text=$3
  sed -i '' "${line}s/.*$/${text}/" ${fileName}
}