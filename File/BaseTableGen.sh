#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
source ./../../BaseShell/Starter/BaseStarter.sh
source ./../../BaseShell/File/BaseTable.sh
#===============================================================
function genDao(){
  local table=$1
  log_info "开始生成${table}的DAO代码"

  local TABLE="${table}"
  local TABLE_NAME=$(basename ${TABLE}|toUnderlineCase|toUpperCase)
  local TABLE_COLUMNS=( "$(file_header ${TABLE})" )
  local TABLE_COLUMNS_UP=( "$(file_header ${TABLE}|toUnderlineCase|toUpperCase)" )
  local tableName=$(basename ${TABLE}|string_firstLetter_toUpperCase)
  gen(){
    echo '#!/usr/bin/env bash'
    echo '# shellcheck disable=SC1091,SC2155'
    echo '#==============================================================='
    echo 'import="$(basename "${BASH_SOURCE[0]}" .sh)_$$"'
    echo 'if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi'
    echo 'eval "${import}=0"'
    echo '#==============================================================='
    echo 'source ./../../BaseShell/Starter/BaseHeader.sh'
    echo 'source ./../../BaseShell/File/BaseTable.sh'
    echo '#==============================================================='
    echo "readonly ${TABLE_NAME}_TABLE='${TABLE}'"
    echo "readonly ${TABLE_NAME}_COLUMNS=( ${TABLE_COLUMNS[*]} )"
    echo "readonly ${TABLE_NAME}_COLUMNS_UP=( ${TABLE_COLUMNS_UP[*]} )"

  #  echo "distinct(){:
  #  }"
  #  echo "or(){
  #  }"
  #  echo "orderBy(){
  #  }"


  #  echo "function ${tableName}_update(){
  #  }"

     echo "function ${tableName}"'_parse(){ _NotBlank "$*" "query can not be null"'
     echo '  local query=$*;'
     echo '  for COLUMN in ${'"${TABLE_NAME}"'_COLUMNS_UP[*]};do'
     echo '  local index=$(eval "echo \${'"${TABLE_NAME}"'_COLUMN_${COLUMN}}")'
     echo '  query=$(echo ${query//${COLUMN}/\$${index}})'
     echo '  done'
     echo '  echo ${query}'
     echo '}'

     echo "function ${tableName}_insert(){"' _NotBlank "$*" "query can not be null"'
     echo '  echo "$*">> "${'${TABLE_NAME}_TABLE'}"'
     echo "}"

     echo "function ${tableName}"'_select(){ _NotBlank "$*" "query can not be null"'
     echo '  local query=$*'
     echo '  query=$('"${tableName}"'_parse "${query}")'
     echo '  local query="awk '\''${query} NR!=1{print \$0}'\'' ${'${TABLE_NAME}_TABLE'}"'
     echo '  log_debug "${query}"'
     echo '  eval "${query}"'
     echo "}"

     echo "function ${tableName}"'_selectOne(){ _NotBlank "$*" "query can not be null"'
     echo '  local query=$*'
     echo '  local result=$('"${tableName}"'_select "${query}"|head -1)'
     echo '  echo ${result}'
     echo "}"

     echo "function ${tableName}"'_count(){ _NotBlank "$*" "query can not be null"'
     echo '  local query=$*'
     echo '  local result=$('"${tableName}"'_select "${query}"|wc -l)'
     echo '  echo ${result}'
     echo "}"

     echo "function ${tableName}"'_line(){ _NotBlank "$*" "query can not be null"'
     echo '  local query=$*'
     echo '  query=$('${tableName}'_parse "${query}")'
     echo '  local query="awk '\''${query} NR!=1{print NR}'\'' ${HOST_INFO_TABLE_TABLE}"'
     echo '  log_debug "${query}"'
     echo '  eval "${query}"'
     echo '}'

     echo "function ${tableName}"'_delete(){ _NotBlank "$*" "query can not be null"'
     echo '  local lines=( $(HostInfoTable_line "$1") )'
     echo '  local query=""'
     echo '  for line in ${lines[*]};do'
     echo '    query+="${line}d;"'
     echo '  done'
     echo '  query="$(echo "${query}"|string_tailRemove)"'
     echo '  sed -i '\'\'' "${query}" "${HOST_INFO_TABLE_TABLE}"'
     echo '  echo "${#lines[@]}"'
     echo '}'

  }

  genColumn(){
     #首字母大写
     local column=$(echo $1|string_firstLetter_toUpperCase)
     #转下划线再转大写
     local column_up=$(echo $1|toUnderlineCase|toUpperCase)
     echo "${TABLE_NAME}_COLUMN_${column_up}='$2'"
     echo "COLUMN_${column_up}='${column_up}'"
     echo "and${column}Between(){ printf \"${column_up}>"'$1 && '${column_up}'<$2 && " ;}'
     echo "and${column}EqualTo(){ printf \"${column_up}=="'\"$*\" && " ;}'
     echo "and${column}EqualToColumn(){ printf \"${column_up}=="'$* && " ;}'
     echo "and${column}GreaterThan(){ printf \"${column_up}>\\\"\$*\\\" && \" ;}"
     echo "and${column}GreaterThanColumn(){ printf \"${column_up}>"'$* && " ;}'
     echo "and${column}GreaterThanOrEqualTo(){ printf \"${column_up}>=\\\"\$*\\\" && \" ;}"
     echo "and${column}GreaterThanOrEqualToColumn(){ printf \"${column_up}>="'$* && " ;}'
     echo "and${column}LessThan(){ printf \"${column_up}<\\\"\$*\\\" && \" ;}"
     echo "and${column}LessThanColumn(){ printf \"${column_up}<"'$* && " ;}'
     echo "and${column}LessThanOrEqualTo(){ printf \"${column_up}<=\\\"\$*\\\" && \" ;}"
     echo "and${column}LessThanOrEqualToColumn(){ printf \"${column_up}<="'$* && " ;}'
     echo "and${column}NotBetween(){ printf \"(${column_up}<"'$1 || '${column_up}'>$2) && " ;}'
     echo "and${column}NotEqualTo(){ printf \"${column_up}!=\\\"\$*\\\" && \" ;}"
     echo "and${column}NotEqualToColumn(){ printf \"${column_up}!=\$* && \" ;}"
  }

  gen > "${tableName}Dao.sh"
  i=1
  for COLUMN in ${TABLE_COLUMNS[*]};do
    genColumn "${COLUMN}" "${i}">> "${tableName}Dao.sh"
    i=$((i+1))
  done
}

