#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155,SC2116,SC2128,SC2178
source ./../../BaseShell/Utils/BaseHeader.sh
#===============================================================================
readonly TABLE_ID='./../../BaseShell/DataBase/ID'
readonly ID_Column_Id='1:id'
readonly ID_Column_Table='2:table'
readonly ID_Column_Num='3:num'
getId(){
  local param=$(timeout 1 cat <&0)
  echo -e "${param}"|awk '{print $1}'
}
setId(){
  local param=$1
  echo -e "1=${param}"
}
andIdEqualTo(){
  local param=$1
  local criteria="\$1==\"${param}\""
  echo -n " && ${criteria}"
}
andIdNotEqualTo(){
  local param=$1
  local criteria="\$1!=${param}"
  echo -n " && ${criteria}"
}
andIdNotNull(){
  local criteria="\$1!=\"${NULL}\""
  echo -n " && ${criteria}"
}
andIdIsNull(){
  local criteria="\$1==\"${NULL}\""
  echo -n " && ${criteria}"
}
andIdEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local result="\$1==\$${index}"
  echo -n " && ${criteria}"
}
andIdNotEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local result="\$1!=\$${index}"
  echo -n " && ${criteria}"
}
andIdGreaterThan(){
  local param=$1
  local criteria="\$1>\"${param}\""
  echo -n " && ${criteria}"
}
andIdGreaterThanColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$1>\$${index}"
  echo -n " && ${criteria}"
}
andIdGreaterThanOrEqualTo(){
  local param=$1
  local criteria="\$1>=\"${param}\""
  echo -n " && ${criteria}"
}
andIdGreaterThanOrEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$1>=\$${index}"
  echo -n " && ${criteria}"
}
andIdLessThan(){
  local param=$1
  local criteria="\$1<\"${param}\""
  echo -n " && ${criteria}"
}
andIdLessThanColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$1<\$${index}"
  echo -n " && ${criteria}"
}
andIdLessThanOrEqualTo(){
  local param=$1
  local criteria="\$1<=\"${param}\""
  echo -n " && ${criteria}"
}
andIdLessThanOrEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$1<=\$${index}"
  echo -n " && ${criteria}"
}
andIdIn(){
  local param=( "$@" )
  local criteria
  for item  in "${param[@]}";do
    criteria+="\$1==\"${item}\" ||"
  done
  echo -n " && ${criteria%%\|\|}"
}
andIdNotIn(){
  local param=( "$@" )
  for item  in "${param[@]}";do
    criteria+="&& \$1!=\"${item}\""
  done
  echo -n " && ${criteria}"
}
andIdBetween(){
  local min=$1;local max=$2
  local criteria="${min}<\$1 && \$1<${max}"
  echo -n " && ${criteria}"
}
andIdNotBetween(){
  local min=$1;local max=$2
  local criteria="${min}>\$1 || \$1>${max}"
  echo -n " && ${criteria}"
}
andIdLike(){
  local param=$1
  local criteria="\$1~/${param}/"
  echo -n " && ${criteria}"
}
andIdNotLike(){
  local param=$1
  local criteria="\$1!~/${param}/"
  echo -n " && ${criteria}"
}
orderByIdAsc(){
  local criteria='1asc==1asc'
  echo -n " && ${criteria}"
}
orderByIdDesc(){
  local criteria='1desc==1desc'
  echo -n " && ${criteria}"
}
withIdDistinct(){
  local criteria='1distinct==1distinct'
  echo -n " && ${criteria}"
}
getTable(){
  local param=$(timeout 1 cat <&0)
  echo -e "${param}"|awk '{print $2}'
}
setTable(){
  local param=$1
  echo -e "2=${param}"
}
andTableEqualTo(){
  local param=$1
  local criteria="\$2==\"${param}\""
  echo -n " && ${criteria}"
}
andTableNotEqualTo(){
  local param=$1
  local criteria="\$2!=${param}"
  echo -n " && ${criteria}"
}
andTableNotNull(){
  local criteria="\$2!=\"${NULL}\""
  echo -n " && ${criteria}"
}
andTableIsNull(){
  local criteria="\$2==\"${NULL}\""
  echo -n " && ${criteria}"
}
andTableEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local result="\$1==\$${index}"
  echo -n " && ${criteria}"
}
andTableNotEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local result="\$1!=\$${index}"
  echo -n " && ${criteria}"
}
andTableGreaterThan(){
  local param=$1
  local criteria="\$2>\"${param}\""
  echo -n " && ${criteria}"
}
andTableGreaterThanColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$1>\$${index}"
  echo -n " && ${criteria}"
}
andTableGreaterThanOrEqualTo(){
  local param=$1
  local criteria="\$2>=\"${param}\""
  echo -n " && ${criteria}"
}
andTableGreaterThanOrEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$1>=\$${index}"
  echo -n " && ${criteria}"
}
andTableLessThan(){
  local param=$1
  local criteria="\$2<\"${param}\""
  echo -n " && ${criteria}"
}
andTableLessThanColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$1<\$${index}"
  echo -n " && ${criteria}"
}
andTableLessThanOrEqualTo(){
  local param=$1
  local criteria="\$2<=\"${param}\""
  echo -n " && ${criteria}"
}
andTableLessThanOrEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$2<=\$${index}"
  echo -n " && ${criteria}"
}
andTableIn(){
  local param=( "$@" )
  local criteria
  for item  in "${param[@]}";do
    criteria+="\$2==\"${item}\" ||"
  done
  echo -n " && ${criteria%%\|\|}"
}
andTableNotIn(){
  local param=( "$@" )
  for item  in "${param[@]}";do
    criteria+="&& \$2!=\"${item}\""
  done
  echo -n " && ${criteria}"
}
andTableBetween(){
  local min=$1;local max=$2
  local criteria="${min}<\$2 && \$2<${max}"
  echo -n " && ${criteria}"
}
andTableNotBetween(){
  local min=$1;local max=$2
  local criteria="${min}>\$2 || \$2>${max}"
  echo -n " && ${criteria}"
}
andTableLike(){
  local param=$1
  local criteria="\$2~/${param}/"
  echo -n " && ${criteria}"
}
andTableNotLike(){
  local param=$1
  local criteria="\$2!~/${param}/"
  echo -n " && ${criteria}"
}
orderByTableAsc(){
  local criteria='2asc==2asc'
  echo -n " && ${criteria}"
}
orderByTableDesc(){
  local criteria='2desc==2desc'
  echo -n " && ${criteria}"
}
withTableDistinct(){
  local criteria='2distinct==2distinct'
  echo -n " && ${criteria}"
}
getNum(){
  local param=$(timeout 1 cat <&0)
  echo -e "${param}"|awk '{print $3}'
}
setNum(){
  local param=$1
  echo -e "3=${param}"
}
andNumEqualTo(){
  local param=$1
  local criteria="\$3==\"${param}\""
  echo -n " && ${criteria}"
}
andNumNotEqualTo(){
  local param=$1
  local criteria="\$3!=${param}"
  echo -n " && ${criteria}"
}
andNumNotNull(){
  local criteria="\$3!=\"${NULL}\""
  echo -n " && ${criteria}"
}
andNumIsNull(){
  local criteria="\$3==\"${NULL}\""
  echo -n " && ${criteria}"
}
andNumEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local result="\$1==\$${index}"
  echo -n " && ${criteria}"
}
andNumNotEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local result="\$1!=\$${index}"
  echo -n " && ${criteria}"
}
andNumGreaterThan(){
  local param=$1
  local criteria="\$3>\"${param}\""
  echo -n " && ${criteria}"
}
andNumGreaterThanColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$1>\$${index}"
  echo -n " && ${criteria}"
}
andNumGreaterThanOrEqualTo(){
  local param=$1
  local criteria="\$3>=\"${param}\""
  echo -n " && ${criteria}"
}
andNumGreaterThanOrEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$1>=\$${index}"
  echo -n " && ${criteria}"
}
andNumLessThan(){
  local param=$1
  local criteria="\$3<\"${param}\""
  echo -n " && ${criteria}"
}
andNumLessThanColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$1<\$${index}"
  echo -n " && ${criteria}"
}
andNumLessThanOrEqualTo(){
  local param=$1
  local criteria="\$3<=\"${param}\""
  echo -n " && ${criteria}"
}
andNumLessThanOrEqualToColumn(){
  local columnName=$1
  local index=$(echo "${columnName}"|awk -F ':' '{print $1}')
  local criteria="\$3<=\$${index}"
  echo -n " && ${criteria}"
}
andNumIn(){
  local param=( "$@" )
  local criteria
  for item  in "${param[@]}";do
    criteria+="\$3==\"${item}\" ||"
  done
  echo -n " && ${criteria%%\|\|}"
}
andNumNotIn(){
  local param=( "$@" )
  for item  in "${param[@]}";do
    criteria+="&& \$3!=\"${item}\""
  done
  echo -n " && ${criteria}"
}
andNumBetween(){
  local min=$1;local max=$2
  local criteria="${min}<\$3 && \$3<${max}"
  echo -n " && ${criteria}"
}
andNumNotBetween(){
  local min=$1;local max=$2
  local criteria="${min}>\$3 || \$3>${max}"
  echo -n " && ${criteria}"
}
andNumLike(){
  local param=$1
  local criteria="\$3~/${param}/"
  echo -n " && ${criteria}"
}
andNumNotLike(){
  local param=$1
  local criteria="\$3!~/${param}/"
  echo -n " && ${criteria}"
}
orderByNumAsc(){
  local criteria='3asc==3asc'
  echo -n " && ${criteria}"
}
orderByNumDesc(){
  local criteria='3desc==3desc'
  echo -n " && ${criteria}"
}
withNumDistinct(){
  local criteria='3distinct==3distinct'
  echo -n " && ${criteria}"
}
or(){
  local criteria1=$(echo "$1")
  read -r -t 1 -a param
  criteria2=$(echo "${param[@]}")

  criteria1=$(echo "${criteria1##\&\&}")
  criteria2=$(echo "${criteria2##\&\&}")

  echo -n " ${criteria1} || ${criteria2}"
}
IDMapper_select(){
  local criteria=$(echo "$1")
  local result=$(IDMapper_run "${criteria}")
  # 排除最后一列行号
  local data=$(echo "${result}"|awk '{$NF="";print $0}')
  echo -e "id table num\\n${data}"|column -t
}
IDMapper_selectOne(){
  local criteria=$(echo "$1")
  local result=$(IDMapper_run "${criteria}")
  # 排除最后一列行号
  local data=$(echo "${result}"|head -1|awk '{$NF="";print $0}')
  echo -e "id table num\\n${data}"|column -t &&   return ${TRUE}
}
IDMapper_count(){
  local criteria=$(echo "$1")
  local result=$(IDMapper_run "$1")
  isNotNull "${result}" && echo "${result}"|wc -l|trim || echo 0
}
IDMapper_insert(){
  local param=( "$1" )
  local init="null null null"
  # 回去最后一个ID,+1为下一个ID
  local id=$(tail -n +2 ${TABLE_User}|tail -1|getId)
  id=$((${id:-0}+1))
  init=$(echo "${init}"|awk -v "id=${id}" '{$1=id}1')

  for filed in ${param[*]};do
     key=$(echo "${filed}"|awk -F '=' '{print $1}')
     value=$(echo "${filed}"|awk -F '=' '{print $2}')
     init=$(echo "${init}"|awk -v "key=${key}" -v "value=${value}" '{$key=value}1')
  done

  echo "${init}" >> ${TABLE_ID} && return ${TRUE}
}
IDMapper_delete(){
  local result=$(IDMapper_run "$1")
  local lines=$(echo -e "${result}"|awk -v 'separator=d;' '{print $NF+1separator}')
  isNotNull "${result}" && sed -i '' "${lines}" ${TABLE_ID} && return ${TRUE}
}
IDMapper_update(){
  local newID=$1
  local criteria=$2
  local IDs=$(IDMapper_run "${criteria}")
  isNull "${IDs}" && return ${FALSE}
  while read -r -t 1 ID;do
    local line=$(echo "${ID}"|awk '{print $NF}')
    local item=$(echo "${ID}"|awk '{$NF="";print $0}')

    for filed in ${newID};do
       key=$(echo "${filed}"|awk -F '=' '{print $1}')
       value=$(echo "${filed}"|awk -F '=' '{print $2}')
       item=$(echo "${item}"|awk -v "key=$key" -v "value=${value}" '{$key=value}1')
    done
    sed -i '' "$((line+1))s:.*:${item}:g" "${TABLE_ID}"
  done <<< "${IDs}"
  return ${TRUE}
}
limit(){
  local param=( "$1" )
  local criteria="${param[*]}limit==${param[*]}limit"
  echo -n " && ${criteria}"
}
offset(){
  local param=( "$1" )
  local criteria="${param[*]}offset==${param[*]}offset"
  echo -n " && ${criteria}"
}
IDMapper_run(){
  local criteria=$(echo "$1"|trim)
  # 去掉请求参数中开头或结尾的 &&、||符号
  criteria=$(echo "${criteria##\&\&}")
  criteria=$(echo "${criteria##\|\|}")
  criteria=$(echo "${criteria%%\&\&}")
  criteria=$(echo "${criteria%%\|\|}")
  # 打印awk语句
  # log_debug "awk (${criteria}) '{print \$0}' ${TABLE_ID}|column -t"
  # 实际的执行语句
  # 不输出表头
  local result=$(awk "(${criteria:-NR!=1}) && NR!=1"'{print $0,NR-1}' ${TABLE_ID})

  # 对指定列进行排序处理
  for item in ${criteria};do
    if [[ $(string_contains "${item}" "distinct") -eq "${TRUE}" ]];then
      distinct=$(echo "${item}" |awk -F 'distinct' '{print $1}')
      result=$(echo "${result}"|sort -n -b -k "${distinct}","${distinct}" -u)
    fi
    if [[ $(string_contains "${item}" "asc") -eq "${TRUE}" ]];then
      asc=$(echo "${item}" |awk -F 'asc' '{print $1}')
      result=$(echo "${result}"|sort -n -b -k"${asc}")
    fi
    if [[ $(string_contains "${item}" "desc") -eq "${TRUE}" ]];then
      desc=$(echo "${item}"|awk -F 'desc' '{print $1}')
      result=$(echo "${result}"|sort -n -b -rk"${desc}")
    fi
  done

  if [[ $(string_contains "${criteria}" "offset") -eq "${TRUE}" ]];then
    for item in ${criteria};do
      if [[ $(string_contains "${item}" "offset") -eq "${TRUE}" ]];then
        offset=$(echo "${item}" |awk -F 'offset' '{print $1}')
        result=$(echo "${result}"|tail -n +$((offset+1)))
      fi
    done
  fi

  if [[ $(string_contains "${criteria}" "limit") -eq "${TRUE}" ]];then
    for item in ${criteria};do
      if [[ $(string_contains "${item}" "limit") -eq "${TRUE}" ]];then
        limit=$(echo "${item}" |awk -F 'limit' '{print $1}')
        result=$(echo "${result}"|head "-${limit}")
      fi
    done
  fi
  echo "${result:-null}"
}
