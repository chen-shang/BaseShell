#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseHeader.sh
#===============================================================================
readonly DataBase_TABLES=('./../../DataBase/DataBase/User')
readonly DataBase_DAO_PATH='/Users/chenshang/Learn/BaseShell/DataBase/Dao'
function gen(){
function genOne(){
local table="$1"
local dbName=$(echo "${table}"|awk -F '/' 'ids=NF-1 {print $ids}')
local tableName=$(echo "${table}"|awk -F '/' '{print $NF}')
log_debug "gen ${dbName} ${tableName}"
local header=$(head -1 < "${table}")
echo '#!/usr/bin/env bash'
echo '# shellcheck disable=SC1091,SC2155,SC2116'
echo 'source ../../BaseShell/Utils/BaseHeader.sh'
echo '#==============================================================================='
echo "readonly TABLE_${tableName}='${table}'"
i=1
for column in ${header};do
  columnName=$(echo "${column}"|toCamelCase)
  echo "readonly ${tableName}_Column_${columnName}='${i}:${column}'"
  ((i++))
done
i=1
for column in ${header};do
columnName=$(echo "${column}"|toCamelCase|string_firstLetter_toUpperCase)
echo -e "get${columnName}(){
  local param
  while read -r -t 1 line;do
    param=\"\${param}\${line}\\\n\"
  done
  param=\$(echo \"\${param##\\\n}\")
  param=\$(echo \"\${param%%\\\n}\")
  echo -e \"\${param}\"|awk '{print \$${i}}'
}"
echo -e "and${columnName}EqualTo(){
  local param=\$1
  local criteria=\"\\\$${i}==\${param}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}NotEqualTo(){
  local param=\$1
  local criteria=\"\\\$${i}!=\${param}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}EqualToColumn(){
  local columnName=\$1
  local index=\$(echo \"\${columnName}\"|awk -F ':' '{print \$1}')
  local result=\"\\\$1==\\$\${index}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}NotEqualToColumn(){
  local columnName=\$1
  local index=\$(echo \"\${columnName}\"|awk -F ':' '{print \$1}')
  local result=\"\\\$1!=\\$\${index}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}GreaterThan(){
  local param=\$1
  local criteria=\"\\\$${i}>\${param}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}GreaterThanColumn(){
  local columnName=\$1
  local index=\$(echo \"\${columnName}\"|awk -F ':' '{print \$1}')
  local criteria=\"\\\$1>\\$\${index}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}GreaterThanOrEqualTo(){
  local param=\$1
  local criteria=\"\\\$${i}>=\${param}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}GreaterThanOrEqualToColumn(){
  local columnName=\$1
  local index=\$(echo \"\${columnName}\"|awk -F ':' '{print \$1}')
  local criteria=\"\\\$1>=\\$\${index}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}LessThan(){
  local param=\$1
  local criteria=\"\\\$${i}'<\${param}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}LessThanColumn(){
  local columnName=\$1
  local index=\$(echo \"\${columnName}\"|awk -F ':' '{print \$1}')
  local criteria=\"\\\$1<\\$\${index}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}LessThanOrEqualTo(){
  local param=\$1
  local criteria=\"\\\$${i}<=\${param}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}LessThanOrEqualToColumn(){
  local columnName=\$1
  local index=\$(echo \"\${columnName}\"|awk -F ':' '{print \$1}')
  local criteria=\"\\\$${i}<=\\$\${index}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}In(){
  local param=( \"\$@\" )
  local criteria
  for item  in \"\${param[@]}\";do
    criteria+=\"\\\$${i}==\${item} ||\"
  done
  echo -n \" && \${criteria%%\|\|}\"
}"
echo "and${columnName}NotIn(){
  local param=( \"\$@\" )
  for item  in \"\${param[@]}\";do
    criteria+=\"&& \\\$${i}!=\${item}\"
  done
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}Between(){
  local min=\$1;local max=\$2
  local criteria=\"\${min}<\\\$${i} && \\\$${i}<\${max}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}NotBetween(){
  local min=\$1;local max=\$2
  local criteria=\"\${min}>\\\$${i} || \\\$${i}>\${max}\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}Like(){
  local param=\$1
  local criteria=\"\\\$${i}~/\${param}/\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}NotLike(){
  local param=\$1
  local criteria=\"\\\$${i}!~/\${param}/\"
  echo -n \" && \${criteria}\"
}"
echo "with${columnName}Asc(){
  local criteria='${i}asc==${i}asc'
  echo -n \" && \${criteria}\"
}"
echo "with${columnName}Desc(){
  local criteria='${i}desc==${i}desc'
  echo -n \" && \${criteria}\"
}"
echo "with${columnName}Distinct(){
  local criteria='${i}distinct==${i}distinct'
  echo -n \" && \${criteria}\"
}"
((i++))
done

echo "or(){
  local criteria1=\$(echo \"\$1\"|trim)
  read -r -t 1 -a param
  criteria2=\$(echo \"\${param[@]}\"|trim)

  criteria1=\$(echo \"\${criteria1##\&\&}\")
  criteria2=\$(echo \"\${criteria2##\&\&}\")

  echo -n \" \${criteria1} || \${criteria2}\"
}"
echo "${tableName}Mapper_select(){
    ${tableName}Mapper_run \"\$1\"
}"
echo "${tableName}Mapper_selectOne(){
    ${tableName}Mapper_run \"\$1 && selectOne==selectOne\"
}"
echo "${tableName}Mapper_count(){
    count=\$(${tableName}Mapper_run \"\$1\"|wc -l)
    echo \$((count-1))
}"
echo "${tableName}Mapper_insert(){
 :
}"
echo "${tableName}Mapper_delete(){
 :
}"
echo "${tableName}Mapper_update(){
 :
}"
echo "${tableName}Mapper_updateByPrimaryKeySelective(){
 :
}"
echo "${tableName}Mapper_updateByPrimaryKey(){
 :
}"
echo "${tableName}Mapper_updateSelective(){
 :
}"
echo "${tableName}Mapper_selectSelective(){
  :
}"
echo "${tableName}Mapper_selectByPrimaryKey(){
  :
}"
echo "${tableName}Mapper_selectByPrimaryKeySelective(){
 :
}"
echo "${tableName}Mapper_selectOneSelective(){
 :
}"

echo "${tableName}Mapper_run(){
  local criteria=\$(echo \"\$1\"|trim)
  # 去掉请求参数中开头或结尾的 &&、||符号
  criteria=\$(echo \"\${criteria##\&\&}\")
  criteria=\$(echo \"\${criteria##\|\|}\")
  criteria=\$(echo \"\${criteria%%\&\&}\")
  criteria=\$(echo \"\${criteria%%\|\|}\")
  # 打印awk语句
  log_debug \"awk (\${criteria}) '{print \\\$0}' \${TABLE_${tableName}}|column -t\"
  # 实际的执行语句
  # 不输出表头
  local result=\$(awk \"(\${criteria:-NR!=1}) && NR!=1\"'{print \$0}' \${TABLE_${tableName}})

  # 对指定列进行排序处理
  for item in \${criteria};do
    if [[ \$(string_contains \"\${item}\" \"distinct\") -eq \"\${TRUE}\" ]];then
      distinct=\$(echo \"\${item}\" |awk -F 'distinct' '{print \$1}')
      result=\$(echo \"\${result}\"|sort -b -k \"\${distinct}\",\"\${distinct}\" -u)
      continue
    fi

    if [[ \$(string_contains \"\${item}\" \"asc\") -eq \"\${TRUE}\" ]];then
      asc=\$(echo \"\${item}\" |awk -F 'asc' '{print \$1}')
      result=\$(echo \"\${result}\"|sort -b -k\"\${asc}\")
      break
    fi
    if [[ \$(string_contains \"\${item}\" \"desc\") -eq \"\${TRUE}\" ]];then
      desc=\$(echo \"\${item}\"|awk -F 'desc' '{print \$1}')
      result=\$(echo \"\${result}\"|sort -b -rk\"\${desc}\")
      break
    fi
  done
  if [[ \$(string_contains \"\${criteria}\" \"selectOne\") -eq \"\${TRUE}\" ]];then
      result=\$(echo \"\${result}\"|head -1)
  fi
  echo -e \"${header}\\\n\${result}\"|column -t
}"

}

for table in "${DataBase_TABLES[@]}";do
  local tableName=$(echo "${table}"|awk -F '/' '{print $NF}')
  genOne "${table}" > "${DataBase_DAO_PATH}/${tableName}Mapper.sh"
done
}
gen