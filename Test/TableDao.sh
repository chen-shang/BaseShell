#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo "${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
source ./../../BaseShell/File/BaseTable.sh
#===============================================================
readonly TABLE_TABLE='./table'
readonly TABLE_COLUMNS=( id name age sex )
readonly TABLE_COLUMNS_UP=( ID NAME AGE SEX )
Table_parse(){
  local query=$*;
  for COLUMN in ${TABLE_COLUMNS_UP[*]};do
  local index=$(eval "echo \${TABLE_COLUMN_${COLUMN}}")
  query=$(echo ${query//${COLUMN}/\$${index}})
  done
  echo ${query}
}
Table_select(){
  local query=$*
  query=$(Table_parse "${query}")
  local query="awk '${query} NR!=1{print \$0}' ${TABLE_TABLE}"
  log_info "${query}"
  eval "${query}"
}
Table_selectOne(){
  local query=$*
  local result=$(Table_select "${query}"|head -1)
  echo ${result}
}
Table_count(){
  local query=$*
  local result=$(Table_select "${query}"|wc -l)
  echo ${result}
}
TABLE_COLUMN_ID='1'
COLUMN_ID='ID'
andIdBetween(){ printf "ID>$1 && ID<$2 && " ;}
andIdEqualTo(){ printf "ID==\"$*\" && " ;}
andIdEqualToColumn(){ printf "ID==$* && " ;}
andIdGreaterThan(){ printf "ID>\"$*\" && " ;}
andIdGreaterThanColumn(){ printf "ID>$* && " ;}
andIdGreaterThanOrEqualTo(){ printf "ID>=\"$*\" && " ;}
andIdGreaterThanOrEqualToColumn(){ printf "ID>=$* && " ;}
andIdLessThan(){ printf "ID<\"$*\" && " ;}
andIdLessThanColumn(){ printf "ID<$* && " ;}
andIdLessThanOrEqualTo(){ printf "ID<=\"$*\" && " ;}
andIdLessThanOrEqualToColumn(){ printf "ID<=$* && " ;}
andIdNotBetween(){ printf "(ID<$1 || ID>$2) && " ;}
andIdNotEqualTo(){ printf "ID!=\"$*\" && " ;}
andIdNotEqualToColumn(){ printf "ID!=$* && " ;}
TABLE_COLUMN_NAME='2'
COLUMN_NAME='NAME'
andNameBetween(){ printf "NAME>$1 && NAME<$2 && " ;}
andNameEqualTo(){ printf "NAME==\"$*\" && " ;}
andNameEqualToColumn(){ printf "NAME==$* && " ;}
andNameGreaterThan(){ printf "NAME>\"$*\" && " ;}
andNameGreaterThanColumn(){ printf "NAME>$* && " ;}
andNameGreaterThanOrEqualTo(){ printf "NAME>=\"$*\" && " ;}
andNameGreaterThanOrEqualToColumn(){ printf "NAME>=$* && " ;}
andNameLessThan(){ printf "NAME<\"$*\" && " ;}
andNameLessThanColumn(){ printf "NAME<$* && " ;}
andNameLessThanOrEqualTo(){ printf "NAME<=\"$*\" && " ;}
andNameLessThanOrEqualToColumn(){ printf "NAME<=$* && " ;}
andNameNotBetween(){ printf "(NAME<$1 || NAME>$2) && " ;}
andNameNotEqualTo(){ printf "NAME!=\"$*\" && " ;}
andNameNotEqualToColumn(){ printf "NAME!=$* && " ;}
TABLE_COLUMN_AGE='3'
COLUMN_AGE='AGE'
andAgeBetween(){ printf "AGE>$1 && AGE<$2 && " ;}
andAgeEqualTo(){ printf "AGE==\"$*\" && " ;}
andAgeEqualToColumn(){ printf "AGE==$* && " ;}
andAgeGreaterThan(){ printf "AGE>\"$*\" && " ;}
andAgeGreaterThanColumn(){ printf "AGE>$* && " ;}
andAgeGreaterThanOrEqualTo(){ printf "AGE>=\"$*\" && " ;}
andAgeGreaterThanOrEqualToColumn(){ printf "AGE>=$* && " ;}
andAgeLessThan(){ printf "AGE<\"$*\" && " ;}
andAgeLessThanColumn(){ printf "AGE<$* && " ;}
andAgeLessThanOrEqualTo(){ printf "AGE<=\"$*\" && " ;}
andAgeLessThanOrEqualToColumn(){ printf "AGE<=$* && " ;}
andAgeNotBetween(){ printf "(AGE<$1 || AGE>$2) && " ;}
andAgeNotEqualTo(){ printf "AGE!=\"$*\" && " ;}
andAgeNotEqualToColumn(){ printf "AGE!=$* && " ;}
TABLE_COLUMN_SEX='4'
COLUMN_SEX='SEX'
andSexBetween(){ printf "SEX>$1 && SEX<$2 && " ;}
andSexEqualTo(){ printf "SEX==\"$*\" && " ;}
andSexEqualToColumn(){ printf "SEX==$* && " ;}
andSexGreaterThan(){ printf "SEX>\"$*\" && " ;}
andSexGreaterThanColumn(){ printf "SEX>$* && " ;}
andSexGreaterThanOrEqualTo(){ printf "SEX>=\"$*\" && " ;}
andSexGreaterThanOrEqualToColumn(){ printf "SEX>=$* && " ;}
andSexLessThan(){ printf "SEX<\"$*\" && " ;}
andSexLessThanColumn(){ printf "SEX<$* && " ;}
andSexLessThanOrEqualTo(){ printf "SEX<=\"$*\" && " ;}
andSexLessThanOrEqualToColumn(){ printf "SEX<=$* && " ;}
andSexNotBetween(){ printf "(SEX<$1 || SEX>$2) && " ;}
andSexNotEqualTo(){ printf "SEX!=\"$*\" && " ;}
andSexNotEqualToColumn(){ printf "SEX!=$* && " ;}