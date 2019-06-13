#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseHeader.sh
#===============================================================================
readonly DataBase_TABLES=('./../../DataBase/DataBase/User' './../../DataBase/DataBase/Machine')
readonly DataBase_DAO_PATH='/Users/chenshang/Learn/BaseShell/DataBase/Dao'
function gen(){
function genOne(){
local table="$1"
local dbName=$(echo "${table}"|awk -F '/' 'ids=NF-1 {print $ids}')
local tableName=$(echo "${table}"|awk -F '/' '{print $NF}')
log_debug "gen ${dbName} ${tableName}"
local header=$(head -1 < "${table}")
echo '#!/usr/bin/env bash'
echo '# shellcheck disable=SC1091,SC2155,SC2116,SC2128,SC2178'
echo 'source ../../BaseShell/Utils/BaseHeader.sh'
echo 'source ./../../BaseShell/DataBase/IDMapper.sh'
echo '#==============================================================================='
echo "readonly TABLE_${tableName}='${table}'"
i=1
for column in ${header};do
  columnName=$(echo "${column}"|toCamelCase|string_firstLetter_toUpperCase)
  echo "readonly ${tableName}_Column_${columnName}='${i}:${column}'"
  ((i++))
done
i=1
for column in ${header};do
columnName=$(echo "${column}"|toCamelCase|string_firstLetter_toUpperCase)
echo -e "get${columnName}(){
  local param=\$(timeout 1 cat <&0)
  echo -e \"\${param}\"|awk '{print \$${i}}'
}"

echo -e "set${columnName}(){
  local param=\$1
  echo -e \"${i}=\${param}\"
}"

echo -e "and${columnName}EqualTo(){
  local param=\$1
  local criteria=\"\\\$${i}==\\\"\${param}\\\"\"
  echo -n \" && \${criteria}\"
}"
echo "and${columnName}NotEqualTo(){
  local param=\$1
  local criteria=\"\\\$${i}!=\${param}\"
  echo -n \" && \${criteria}\"
}"
echo -e "and${columnName}NotNull(){
  local criteria=\"\\\$${i}!=\\\"\${NULL}\\\"\"
  echo -n \" && \${criteria}\"
}"
echo -e "and${columnName}IsNull(){
  local criteria=\"\\\$${i}==\\\"\${NULL}\\\"\"
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
  local criteria=\"\\\$${i}>\\\"\${param}\\\"\"
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
  local criteria=\"\\\$${i}>=\\\"\${param}\\\"\"
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
  local criteria=\"\\\$${i}<\\\"\${param}\\\"\"
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
  local criteria=\"\\\$${i}<=\\\"\${param}\\\"\"
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
    criteria+=\"\\\$${i}==\\\"\${item}\\\" ||\"
  done
  echo -n \" && \${criteria%%\|\|}\"
}"
echo "and${columnName}NotIn(){
  local param=( \"\$@\" )
  for item  in \"\${param[@]}\";do
    criteria+=\"&& \\\$${i}!=\\\"\${item}\\\"\"
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
echo "orderBy${columnName}Asc(){
  local criteria='${i}asc==${i}asc'
  echo -n \" && \${criteria}\"
}"
echo "orderBy${columnName}Desc(){
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
  local criteria1=\$(echo \"\$1\")
  read -r -t 1 -a param
  criteria2=\$(echo \"\${param[@]}\")

  criteria1=\$(echo \"\${criteria1##\&\&}\")
  criteria2=\$(echo \"\${criteria2##\&\&}\")

  echo -n \" \${criteria1} || \${criteria2}\"
}"
echo "${tableName}Mapper_select(){
  local criteria=\$(echo \"\$1\")
  local result=\$(${tableName}Mapper_run \"\${criteria}\")
  # 排除最后一列行号
  local data=\$(echo \"\${result}\"|awk '{\$NF=\"\";print \$0}')
  echo -e \"${header}\\\n\${data}\"|column -t
}"
echo "${tableName}Mapper_selectOne(){
  local criteria=\$(echo \"\$1\")
  local result=\$(${tableName}Mapper_run \"\${criteria}\")
  # 排除最后一列行号
  local data=\$(echo \"\${result}\"|head -1|awk '{\$NF=\"\";print \$0}')
  echo -e \"${header}\\\n\${data}\"|column -t &&   return \${TRUE}
}"
echo "${tableName}Mapper_count(){
  local criteria=\$(echo \"\$1\")
  local result=\$(${tableName}Mapper_run \"\$1\")
  isNotNull \"\${result}\" && echo \"\${result}\"|wc -l|trim || echo 0
}"
echo "${tableName}Mapper_insert(){
  local param=( \"\$1\" )
  log_debug \"inset into ${tableName} with \${param}\"
  local init=\"$(eval printf %.snull'\ '  \{1..$((${i}-1))\}|trim)\"
  # 回去最后一个ID,+1为下一个ID
  local criteria=\$(andTableEqualTo \"${tableName}\")
  local ID=\$(IDMapper_run \"\${criteria}\")
  id=\$(echo \"\${ID}\"|getNum)
  id=\$((\${id:-0}+1))
  init=\$(echo \"\${init}\"|awk -v \"id=\${id}\" '{\$1=id}1')

  for filed in \${param[*]};do
     key=\$(echo \"\${filed}\"|awk -F '=' '{print \$1}')
     value=\$(echo \"\${filed}\"|awk -F '=' '{print \$2}')
     init=\$(echo \"\${init}\"|awk -v \"key=\${key}\" -v \"value=\${value}\" '{\$key=value}1')
  done

  echo \"\${init}\" >> \${TABLE_${tableName}}
  isNull \"\${ID}\" && IDMapper_insert \"\$(setTable \"${tableName}\" && setNum \"\${id}\")\" || IDMapper_update \"\$(setTable \"${tableName}\" && setNum \"\${id}\")\" \"\${criteria}\"
  return ${TRUE}
}"
echo "${tableName}Mapper_delete(){
  local result=\$(${tableName}Mapper_run \"\$1\")
  local lines=\$(echo -e \"\${result}\"|awk -v 'separator=d;' '{print \$NF+1separator}')
  isNotNull \"\${result}\" && sed -i '' \"\${lines}\" \${TABLE_${tableName}} && return \${TRUE}
}"
echo "${tableName}Mapper_update(){
  local new${tableName}=\$1
  local criteria=\$2
  local ${tableName}s=\$(${tableName}Mapper_run \"\${criteria}\")
  isNull \"\${${tableName}s}\" && return \${FALSE}
  while read -r -t 1 ${tableName};do
    local line=\$(echo \"\${${tableName}}\"|awk '{print \$NF}')
    local item=\$(echo \"\${${tableName}}\"|awk '{\$NF=\"\";print \$0}')

    for filed in \${new${tableName}};do
       key=\$(echo \"\${filed}\"|awk -F '=' '{print \$1}')
       value=\$(echo \"\${filed}\"|awk -F '=' '{print \$2}')
       item=\$(echo \"\${item}\"|awk -v \"key=\$key\" -v \"value=\${value}\" '{\$key=value}1')
    done
    sed -i '' \"\$((line+1))s:.*:\${item}:g\" \"\${TABLE_${tableName}}\"
  done <<< \"\${${tableName}s}\"
  return \${TRUE}
}"
echo "limit(){
  local param=( \"\$1\" )
  local criteria=\"\${param[*]}limit==\${param[*]}limit\"
  echo -n \" && \${criteria}\"
}"
echo "offset(){
  local param=( \"\$1\" )
  local criteria=\"\${param[*]}offset==\${param[*]}offset\"
  echo -n \" && \${criteria}\"
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
  local result=\$(awk \"(\${criteria:-NR!=1}) && NR!=1\"'{print \$0,NR-1}' \${TABLE_${tableName}})

  # 对指定列进行排序处理
  for item in \${criteria};do
    if [[ \$(string_contains \"\${item}\" \"distinct\") -eq \"\${TRUE}\" ]];then
      distinct=\$(echo \"\${item}\" |awk -F 'distinct' '{print \$1}')
      result=\$(echo \"\${result}\"|sort -n -b -k \"\${distinct}\",\"\${distinct}\" -u)
    fi
    if [[ \$(string_contains \"\${item}\" \"asc\") -eq \"\${TRUE}\" ]];then
      asc=\$(echo \"\${item}\" |awk -F 'asc' '{print \$1}')
      result=\$(echo \"\${result}\"|sort -n -b -k\"\${asc}\")
    fi
    if [[ \$(string_contains \"\${item}\" \"desc\") -eq \"\${TRUE}\" ]];then
      desc=\$(echo \"\${item}\"|awk -F 'desc' '{print \$1}')
      result=\$(echo \"\${result}\"|sort -n -b -rk\"\${desc}\")
    fi
  done

  if [[ \$(string_contains \"\${criteria}\" \"offset\") -eq \"\${TRUE}\" ]];then
    for item in \${criteria};do
      if [[ \$(string_contains \"\${item}\" \"offset\") -eq \"\${TRUE}\" ]];then
        offset=\$(echo \"\${item}\" |awk -F 'offset' '{print \$1}')
        result=\$(echo \"\${result}\"|tail -n +\$((offset+1)))
      fi
    done
  fi

  if [[ \$(string_contains \"\${criteria}\" \"limit\") -eq \"\${TRUE}\" ]];then
    for item in \${criteria};do
      if [[ \$(string_contains \"\${item}\" \"limit\") -eq \"\${TRUE}\" ]];then
        limit=\$(echo \"\${item}\" |awk -F 'limit' '{print \$1}')
        result=\$(echo \"\${result}\"|head \"-\${limit}\")
      fi
    done
  fi
  echo \"\${result:-null}\"
}"
}

for table in "${DataBase_TABLES[@]}";do
  local tableName=$(echo "${table}"|awk -F '/' '{print $NF}')
  genOne "${table}" > "${DataBase_DAO_PATH}/${tableName}Mapper.sh"
done
}
gen