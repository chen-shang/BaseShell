# 序
Shell脚本实在是太灵活了,相比标准的Java、C、C++ 等,它不过是一些现有命令的堆叠,这是他的优势也是他的劣势,太灵活导致不容易写规范。本人在写Shell脚本的过程中形成了自己一些规范,这些规范还在实践中,在此分享出来.

# Shell介绍
Shell中文译名叫 壳(ke,又读qiao) 外壳的意思,有壳就要有核.核指的是内核,内核即操作系统**内**的**核**心代码,内核是操作系统对计算机硬件资源(例如显示器、硬盘、内存等等)进行调度的唯一通道,也就是说所有对计算机发出的指令,例如使蜂鸣器鸣响、点亮键盘背光、复制粘贴等等都需要经过内核来操作才行,这无论如何你是跨越不过去的。

首先我们要明白,Shell是一种解释型语言,需要Shell解释器来解释执行,每读一行就执行一行。历史上出现过很多Shell解释器,例如 sh,bash,csh,zsh 等等,不同的Shell有不同的词法和语法,就好比不同的方言。用不同的Shell其实指的仅仅是更换了脚本解释器而已。要注意的是有些命令在不同的解释器中会有不同的表现,这也是为什么我们的脚本一移植到别人电脑上就不可用的原因之一。

坑一:echo 在 zsh 和其他 Shell解释器中对特殊字符转义的输出就不同。

以下是切换到bash后 echo 命令的输出
```
chenshang@chenshangMacBook-Pro:~$ bash
chenshang@chenshangMacBook-Pro:~$ echo \\
\
chenshang@chenshangMacBook-Pro:~$ echo \\\\
\\
chenshang@chenshangMacBook-Pro:~$ zsh
chenshangMacBook-Pro% echo \\
\
chenshangMacBook-Pro% echo \\\\
\
```
坑二: 数组使用方式不同
```
chenshang@chenshangMacBook-Pro:~$ bash
chenshang@chenshangMacBook-Pro:~$ a=(1 2 3)
chenshang@chenshangMacBook-Pro:~$ echo ${a}
1

chenshang@chenshangMacBook-Pro:~$ zsh
chenshangMacBook-Pro% a=(1 2 3)
chenshangMacBook-Pro% echo ${a}
1 2 3
chenshangMacBook-Pro%
```
总之,Shell脚本中的坑很多,林林总总,写脚本的时候一定要小心,否则脚本的移植性堪忧。这也就是为什么Shell不适合开发大型应用的原因之一。但辅助开发还是绰绰有余的。尤其是在运维服务器的过程中,与linux的亲和性让它占尽了优势。

本Shell规约是以bash为标准,在Mac OS 10.14上进行验证。
```
chenshang@chenshangMacBook-Pro:~$ sw_vers
ProductName:	Mac OS X
ProductVersion:	10.14
chenshang@chenshangMacBo    ok-Pro:~$ uname -a
BuildVersion:	18A391Darwin chenshangMacBook-Pro.local 18.0.0 Darwin Kernel Version 18.0.0: Wed Aug 22 20:13:40 PDT 2018; root:xnu-4903.201.2~1/RELEASE_X86_64 x86_64
chenshang@chenshangMacBook-Pro:~$ echo $0
-bash
chenshang@chenshangMacBook-Pro:~$ echo ${SHELL}
/usr/local/bin/bash
chenshang@chenshangMacBook-Pro:~$ bash -version
GNU bash, version 5.0.2(1)-release (x86_64-apple-darwin18.2.0)
Copyright (C) 2019 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```
Shell既是一种脚本编程语言,也是一个连接内核和用户的软件.既然他是一门语言就免不了两大要素:词法和语法,首先有哪些词汇(保留词、关键字),词汇有哪些分类(数据类型),其次这些词汇如何表达语意(也就是语法)。Shell编程指的并不是编写这个工具,而是指利用现有的Shell工具进行编程,写出来的程序是轻量级的脚本,我们叫做Shell脚本。Shell的语法是从C继承过来的,因此我们在写Shell脚本的时候往往能看到C语言的影子。因为初代Unix内核中的Shell解释器最主要的两个贡献者是肯汤普森和丹尼斯里奇,而丹尼斯里奇是C语言的发明者,肯汤普森则用C语言重写了之前的Unix内核。

# 基础语法
## 说明
写Shell脚本考验是的你对各个命令或工具使用的熟练程度。基本命令必须要熟练掌握,常用命令要知道基本功能和基本参数,生僻命令只需要知道大概即可,要学会使用man手册查看命令的帮助文档。对于一些命令不必死记硬背,用的时候查一下解决问题即可。

基本命令例如 /bin 目录下的
```
chenshang@chenshangMacBook-Pro:~$ ls /bin/
[         chmod     date      echo      hostname  launchctl ls        pax       rm        sleep     tcsh      wait4path
bash      cp        dd        ed        kill      link      mkdir     ps        rmdir     stty      test      zsh
cat       csh       df        expr      ksh       ln        mv        pwd       sh        sync      unlink
```

常用命令和工具
```
sed、awk、grep、tr、column、ssh、scp、expect、ps、top、htop、tree、pstree、curl、wget、java相关的工具
```

## 运行方式
既可以在命令行交互的运行,又可以将指令固化到文件中执行
```
chenshang@chenshangMacBook-Pro:~$ ./test.sh
\
1 2 3
chenshang@chenshangMacBook-Pro:~$ cat test.sh
#!/bin/zsh
echo \\\\
a=(1 2 3)
echo "${a}"
chenshang@chenshangMacBook-Pro:~$ vim test.sh
chenshang@chenshangMacBook-Pro:~$ ./test.sh
\\
1
chenshang@chenshangMacBook-Pro:~$
```
## 关于首行
```
【推荐】#!/usr/bin/env bash
说明:脚本用env启动的原因,是因为脚本解释器在linux中可能被安装于不同的目录,env可以在系统的PATH目录中查找。
```
我们往往看到大多数Shell脚本的第一行是 #!/bin/bash 这句话,当然也有 #!/bin/sh、#!/usr/bin/bash,这几种写法也都算是正确,
当然还有一些野路子的写法,为了避免误导这里就不示例了。本Shell规约并不推荐使用上面的任何一种,而是使用 #!/usr/bin/env bash 这种。

首行关系到运行脚本的时候究竟使用哪种Shell解释器。这也说明Shell是一种解释性语言,脚本从上到下每读一行就执行一行,
在遇到第一行是 #!/bin/bash 的时候就会加载 bash 相关的环境,在遇到 #!/bin/sh 就会加载 sh 相关的环境,
避免在执行脚本的时候遇到意想不到的错误。但一开始我并不知道我电脑上安装了哪些Shell,默认使用的又是哪一个Shell,
我脚本移植到别人的计算机上执行,我更不可能知道别人的计算机是Ubuntu还是Arch或是Centos。为了提高程序的移植性,
本Shell规约规定使用 #!/usr/bin/env bash, #!/usr/bin/env bash 会自己判断使用的Shell是目录在哪,并加载相应的环境变量。

我们看一下下面一段脚本,在改变第一行头部的时候,shellcheck给出的建议是什么
$ cat test.sh

```bash
function main(){
  local string="Hello World!!!"
  echo $string
}
```

使用 #!/bin/bash 或 #!/usr/bin/env bash
```
$ Shellchek test.sh
In base_file.sh line 4:
  echo $string
       ^-- SC2086: Double quote to prevent globbing and word splitting.
```

使用 #!/bin/zsh
```
$ Shellchek test.sh
In base_file.sh line 1:
#!/bin/zsh
^-- SC1071: ShellCheck only supports sh/bash/dash/ksh scripts. Sorry!
```

使用 #!/bin/sh
```
$ Shellchek test.sh
In base_file.sh line 2:
function main(){
^-- SC2112: 'function' keyword is non-standard. Delete it.
In base_file.sh line 3:
  local string="Hello World!!!"
  ^-- SC2039: In POSIX sh, 'local' is undefined.
In base_file.sh line 4:
  echo $string
       ^-- SC2086: Double quote to prevent globbing and word splitting.
```

这一行不写大多数时候我们运行脚本的时候也没有问题,但在使用Shellcheck进行检查的时候,会提示
```
^-- SC2148: Tips depend on target Shell and yours is unknown. Add a shebang.
```

如果使用Intellij IDEA 也会提示 `add shebang line`

当你点击 `Add shebangline` 的时候它会自动添加 `#!/usr/bin/env bash` ,这也是为什么本Shell规约推荐使用 `#!/usr/bin/env bash` 的原因之一

> shebang 维基百科
>> 在计算机科学中,Shebang（也称为 Hashbang ）是一个由井号和叹号构成的字符序列 #! ,其出现在文本文件的第一行的前两个字符。 在文件中存在 Shebang 的情况下,类 Unix 操作系统的程序载入器会分析 Shebang 后的内容,将这些内容作为解释器指令,并调用该指令,并将载有 Shebang 的文件路径作为该解释器的参数[1]。

>> 例如,以指令`#!/bin/sh`开头的文件在执行时会实际调用 `/bin/sh` 程序（通常是 Bourne Shell 或兼容的 Shell,例如 bash、dash 等）来执行。这行内容也是 Shell 脚本的标准起始行。

## 数据类型
### 字符串
shell语言是一门弱类型语言,无论输入的是字符串还是数字,shell都是按照字符串类型来进行存储的,具体属于什么数据类型,shell会根据上下文进行确定,字符串可以用单引号,也可以用双引号,也可以不用引号。单双引号的区别跟PHP类似。

区别
1. 单引号里的任何字符都会原样输出,单引号字符串中的变量是无效的；
2. 单引号字串中不能出现单独一个的单引号（对单引号使用转义符后也不行）,但可成对出现,作为字符串拼接使用。
3. 双引号里可以有变量(这在编程语言里面叫字符串插值)和转义字符

### Shell数组
#### 定义数组
bash支持一维数组（不支持多维数组）,并且没有限定数组的大小。类似于 C 语言,数组元素的下标由 0 开始编号。获取数组中的元素要利用下标,下标可以是整数或算术表达式,其值应大于或等于 0。在 Shell 中,用括号来表示数组,数组元素用"空格"符号分割开。

定义数组的一般形式为：数组名=(值1 值2 ... 值n).例如：
``` 
array=(value0 value1 value2 value3)
或者
array=(
value0
value1
value2
value3
)
还可以单独定义数组的各个分量：
array[0]=value0
array[1]=value1
array[n]=valueN
```
可以不使用连续的下标,而且下标的范围没有限制。

#### 读取数组
```
读取数组元素值的一般格式是：${数组名[下标]}。
例如：valuen=${array[n]}
使用 @ 符号可以获取数组中的所有元素。
例如：echo ${array[@]}
```
#### 数组长度
```
取得数组元素的个数 
length=${#array[@]} 
或者 
length=${#array[*]}
取得数组单个元素的长度 
lengthn=${#array[n]}
```

本Shell规约规定
```
【强制】传递数组使用 "${list[*]}" 形式
【强制】接收数组使用 array=($*) 形式 
```
示例：
```bash
# @return the number of elements in this list
function list_size(){
  local array=($1);local size=${#array[*]}
  echo "${size}"
}
size=$(list_size "${list[*]}")
assertEquals "${size}" "2"
```

## Shell变量
```bash
function f1(){
  local var="Hello"
  echo "${var} World"
}
```
注意,变量名和等号之间不能有空格,这可能和你熟悉的所有编程语言都不一样。同时,变量名的命名须遵循如下规则：(参考<a href="#style">命名风格</a>)

1) 局部变量 局部变量在脚本或命令中定义,仅在当前shell实例中有效,其他shell启动的程序不能访问局部变量。
2) 环境变量 所有的程序,包括shell启动的程序,都能访问环境变量,有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。

本shell规约规定:
```
【强制】变量取值用 "${}", 使用 {} 包裹,给所有变量加上花括号,防止产生歧义
【强制】变量取值用 "${}", 使用 "" 包裹,防止分词
【强制】若需要将调用的函数的返回结果赋值给local变量,使用 $(),不推荐使用 ``
【强制】常量使用 readonly 修饰
```
### 只读变量
使用 readonly 命令可以将变量定义为只读变量,只读变量的值不能被改变。
### 删除变量
使用 unset 命令可以删除变量,变量被删除后不能再次使用。unset 命令不能删除只读变量。

## 关于注释
除脚本首行外,所有以 `#` 开头的语句都将成为注释。

示例:
```bash
# 主函数 []<-()                   <-------函数注释这样写
function main(){
  local var="Hello World!!!"
  echo "${var}"
}
# info级别的日志 []<-(msg:String)  <-------带入参的函数注释
log_info(){
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][$$]: [info] $*" >&2
}
# error级别的日志 []<-(msg:String) <-------带入参的函数注释
log_error(){
  # todo [error]用红色显示         <------函数内注释
  local msg=$1 #将要输出的日志内容  <------变量的注释紧跟在变量的后面
  if [[ x"${msg}" != x"" ]];then
    # 注释                        <-------函数内注释 `#` 与缩进格式对整齐
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][$$]:[error] $*" >&2
  fi
}
```
```
【强制】函数需有注释标识该函数的用途、入参变量、函数的返回值类型
【强制】函数的注释 `#` 顶格写, 井号后面紧跟一个空格,对于该格式的要求是为了最后生成函数的帮助文档是用的(markdown语法),然后是注释的内容,注释尽量简短且在一行,最后跟的是函数的类型。
【强制】函数内注释 `#` 与缩进格式对整齐
【强制】变量的注释紧跟在变量的后面,不推荐换行写注释
```

# 关于函数
函数定义的形式是
```
function main(){
  #函数执行的操作
  #函数的返回结果
}
```
或
```
main(){
  #函数执行的操作
  #函数的返回结果
}
```
```
【推荐】使用关键字 `function` 显示定义的函数为 public 的函数,可以供 外部脚本以 `sh 脚本 函数 函数入参` 的形式调用,可以认为成Java当中的public的方法
【推荐】未使用关键字 `function` 显示定义的函数为 private 的函数, 仅供本脚本内部调用,可以认为成Java中的私有方法,注意这种private是人为规定的,并不是Shell的语法,不推荐以 `sh 脚本 函数 函数入参` 的形式调用,注意是不推荐而不是不能。

说明:本Shell规约这样做的目的就在于使脚本具有一定的封装性,看到 `function` 修饰的就知道这个函数能被外部调用, 没有被修饰的函数就仅供内部调用。你就知道如果你修改了改函数的影响范围. 如果是 被function 修饰的函数,修改后可能影响到外部调用他的脚本, 而修改未被function修饰的函数的时候,仅仅影响本文件中其他函数。
```
如 core.sh 脚本内容如下是
```bash
# 重新设置DNS地址 []<-()
function setNameServer(){
  log_info "setNameServer is ok"
}
# info级别的日志 []<-(msg:String)
log_info(){
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')][$$]: \033[32m [info] \033[0m $*" >&2
}
# error级别的日志 []<-(msg:String)
log_error(){
  # todo [error]用红色显示
  echo -e "[$(date +'%Y-%m-%dT%H:%M:%S%z')][$$]: \033[31m [error] \033[0m $*" >&2
}
```

则我可以使用 `sh core.sh setNameServer` 的形式调用  `set_name_server` 函数,
但就不推荐使用 `sh core.sh log_info "Hello World"` 的形式使用 `log_info` 和 `log_error` 函数,注意是不推荐不是不能。

## 函数调用
变量、函数调用必须在函数声明之后,也就是说在用一个函数的时候,这一行命令的前面必须出现了该函数,因为Shell的执行是从上向下解释执行的。

同一个脚本内调用、执行调用另一个脚本、调用另一脚本中的命令实例
```bash
#!/usr/bin/env bash
source ./../../BaseShell/Log/BaseLog.sh
function f1(){
  echo "I am f1"
}
function main(){
  log_info "LINENO:${LINENO} 开始执行"      #调用 ./../../BaseShell/Log/BaseLog.sh 中的函数,需要先用source BaseLog.sh
  f1                                      #在函数内部调用当前脚本内的函数
  log_success "LINENO:${LINENO} 结束执行"   #调用 ./../../BaseShell/Log/BaseLog.sh 中的函数
}
main                                       #在脚本内部调用当前脚本内的函数
bash ChangBaiShanFetcher.sh                #执行其他脚本
bash ChangBaiShanFetcher.sh main           #执行其他脚本的main方法,前提是 ChangBaiShanFetcher.sh 脚本 支持按函数名调用
```
## 函数参数
| 参数 | 说明                                                                                                                   |   |
|----------|------------------------------------------------------------------------------------------------------------------------|---|
| $#       | 传递到脚本的参数个数                                                                                                   |   |
| $*       | 以一个单字符串显示所有向脚本传递的参数。如"$*"用「"」括起来的情况、以"$1 $2 … $n"的形式输出所有参数。                  |   |
| $$       | 脚本运行的当前进程ID号                                                                                                 |   |
| $!       | 后台运行的最后一个进程的ID号                                                                                           |   |
| $@       | 与$*相同,但是使用时加引号,并在引号中返回每个参数。如"$@"用「"」括起来的情况、以"$1" "$2" … "$n" 的形式输出所有参数。 |   |
| $-       | 显示Shell使用的当前选项,与set命令功能相同。                                                                           |   |
| $?       | 显示最后命令的退出状态。0表示没有错误,其他任何值表明有错误。                                                          |   |
```
【强制】 在函数内部首先使用有意义的变量名接受参数,然后在使用这些变量进行操作,禁止直接操作$1,$2等,除非这些变量只用一次
```
## 函数注释
函数类型的概念是从函数编程语言中的概念偷过来的,Shell函数的函数类型指的是函数的输入到函数的输入的映射关系
```bash
# 主函数 []<-()                  <-------函数注释这样写
function main(){
  local var="Hello World!!!"
  echo ${var}
}
# info级别的日志 []<-(msg:String)  <-------带入参的函数注释
log_info(){
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')][$$]: [info] $*" >&2
}
```
说明:
> main函数的函数类型是 []<-() , <- 左侧表的是函数的返回值类型 用[]包裹, 右侧是函数的参数类型 用()包裹,多个参数用 ',' 分隔,参数的描述是从 Scala 语言中偷过来, 先是参数名称 然后是参数类型 中间用:分隔

> 对于main函数的注释来说, `#` 顶格写,后面紧跟一个空格,其实这样写是遵循的markdown的语法, 后面再跟一个空格,然后是 []<-(),代表这个函数没有入参也没有返回值,这个函数的目的就是执行这个这个函数中的命令,但我不关心这个函数的返回值。也就是利用函数的副作用来完成我们想要的操作。

> 对于log_info 也是一样 不过 最后的函数类型是 []<-(msg:String) 代表入参是一个string类型的信息,然后也没有返回值。
关于函数的返回值,我理解的函数的返回值有两种形式,一种是显示的return一种是隐式的echo

以下是几种常见的写法
```
[]<-()
[String]<-(var1:String,var2:String)
[Boolean]<-(var1:String,var2:Int)
[]<-(var1:String)
```
## 返回值
Shell 函数的返回值比较复杂,获取函数的返回值又有多种方式.一般来说,一个函数内的所有标准输出都作为函数的返回值。注意是标准输出。
我们先来说,我们执行一条命令的时候, 比如 pwd 正常情况下它输出的结果是 当前所处的目录
```
Last login: Sat Jan 20 17:39:16 on ttys000
chenshang@chenshangMacBook-Pro:~$ pwd
/Users/chenshang
```
注意我说的是正常情况下,那异常情况下呢?输出的结果又是什么?输出的结果有可能五花八门!所以,Shell中必然有一种状态来标识一条命令是否执行成功,也就是命令执行结果的状态。那这种状态是怎么标识的,这就引出了Shell中一个反人类的规定,就是 0代表真、成功的含义。非零代表假、失败的含义。

所以 pwd 这条命令如果执行成功的话,命令的执行结果状态一定是0,然后返回值才是当前目录。如果这条命令执行失败的话,命令的执行结果状态一定不是0,有可能是1 代表命令不存在,然后输出 not found,也有可能执行结果状态是2 代表超时,然后什么也不输出。(不要以为pwd这种linux内带的命令就一定执行成功,有可能你拿到的就是一台阉割版的linux呢)

### 显示return
return 用来显示的返回函数的返回结果,例如
```bash
# 检查当前系统版本 [Integer]<-()
function checkVersion(){
  (log_info "check_version ...") #log_info是我写的工具类中的一个函数
  local version #这里是先定义变量,在对变量进行赋值,我们往往是直接初始化,而不是像这样先定义在赋值,这里只是告诉大家可以这么用
  version=$(sed -r 's/.* ([0-9]+)\..*/\1/' /etc/redhat-release)
  (log_info "centos version is ${version}")
  return "${version}" 
}
```
显示的return结果,返回值只能是[0-255]的数值,常常用在状态判断的时候

这样这个函数的返回值是一个数值类型,我在脚本的任何地方调用 checkVersion 这个函数后,使用 $? 获取返回值
```bash
checkVersion
version=$?
echo "${version}"
```
注意这里不用 `version=$(check_version)` 这种形式获取结果,这样也是获取不到结果的
  
本Shell规约规定:
```
【推荐】不推荐使用return方式返回,推荐使用echo方式返回结果
【推荐】返回结果类型是Boolean类型,也就是说函数的功能是起判断作用,返回结果是真或者假的时候使用显示 return 返回结果
```
例如
```bash
# 检查网络 [Boolean]<-()
function check_network(){
  (log_info "check_network ...")
  for((i=1;i<=3;i++));do
    local http_code=$(curl -I -m 10 -o /dev/null -s -w %\{http_code\}  www.baidu.com)
    if [[ ${http_code} -eq 200 ]];then
      (log_info "network is ok")
      return ${TRUE}
    fi
  done
  (log_error "network is not ok")
  return ${FALSE}
}
```

### 隐式echo
echo 用来显示的返回函数的返回结果,例如
```bash
# 将json字符串格式化树形结构 [String]<-(json_string:String)
function json_format(){
  local json_string=$1
  echo "${json_string}"|jq . #jq是Shell中处理json的一个工具
}
```
函数中所有的echo照理都应该输出到控制台上 例如
```
json_format "{\"1\":\"one\"}"
```
你会在控制台上看到如下输出
```json
{
  "1": "one"
}
```
但是一旦你用变量接收函数的返回值,这些本该输出到控制台的结果就都会存储到你定义的变量中 例如
```bash
json=$(json_format "{\"1\":\"one\"}")
echo "${json}" #如果没有这句,上面的语句执行完成后,不会在控制台有任何的输出
```
我们把 json_format 改造一下
```bash
# 将json字符串格式化树形结构 [String]<-(json_string:String)
function json_format(){
  local json_string=$1
  echo "为格式化之前:${json_string}" #其实新添加的这一句只是用来记录一行日志的,但是返回结果会被外层变量接收
  echo "${json_string}"|jq . #jq是Shell中处理json的一个工具
}
```
echo "为格式化之前:${json_string}" 其实新添加的只一句只是用来记录一行日志的,但是json=$(json_format "{\"1\":\"one\"}")
变量 json 也会将这句话作为返回结果进行接收,但这是我不想要看到的。
解决这个问题需要了解重定向相关
```bash
# 将json字符串格式化树形结构 [String]<-(json_string:String)
function json_format(){
  local json_string=$1
  log_trace "为格式化之前:${json_string}" #其实新添加的只一句只是用来记录一行日志的
  echo "${json_string}"|jq . #jq是Shell中处理json的一个工具
}
```

# 关于分支
```bash
HEAD_KEYWORD parameters; BODY_BEGIN
  BODY_COMMANDS
BODY_END
```
```
【强制】将HEAD_KEYWORD和初始化命令或者参数放在第一行；
【强制】将BODY_BEGIN同样放在第一行；
【强制】复合命令中的BODY部分以2个空格缩进；
【强制】BODY_END部分独立一行放在最后；
【推荐】parameters部分test表达式变量取值都用""包裹；
【推荐】parameters部分test表达式统一使用=等符号, 在明确是数字的时候可以使用 -eq等参数；
```
1. if
```bash
if [[ condition ]]; then
  echo statements
fi

if [[ condition ]]; then
  echo statements
else
  echo statements
fi

if [[ condition ]]; then
  echo statements
elif [[ condition ]]; then
  echo statements
else
  echo statements
fi
```
2. while
```bash
while [[ condition ]]; do
  echo statements
done

while read -r item ;do
  echo "${item}"
done < 'file_name'
```
3. until
```bash
until [[ condition ]]; do
  echo statements
done
```
4. for
```bash
for (( i = 0; i < 10; i++ )); do
  echo statements
done

for item in ${array}; do
  echo "${item}"
done
```
5. case
```bash
case word in
  pattern )
    #statements
    ;;
    *)
    #statements
    ;;
esac
```
```
【强制】 if\while\until 后面的判断 使用 双中括号`[[]]`
```
# 数学计算
注释 1：shell 的自加、自减操作符在使用上和 c 语言一样。-- 或者 ++ 出现在变量前面是前缀形式,先运算后赋值；-- 或者 ++ 出现在变量后面是后缀形式,先赋值后运算。
```
【推荐】明确知道变量是整数,计算使用$(())包裹计算,(())内对变量的操作不用$取值
 正确 a=$((1+1))
 反例 a=$(($a++))
【推荐】复杂计算使用bc计算器,前提是得安装bc计算器命令
```

# 关于进程间通信
## 管道
前一个命令的标砖输出作为下一个命令的标准输入`ps -ef|grep java`
## 有名管道
命名管道也被称为FIFO文件,是一种特殊的文件。由于linux所有的事物都可以被视为文件,所以对命名管道的使用也就变得与文件操作非常统一。

若对管道文件直接进行操作,可实现阻塞读写,如果没有读则写阻塞,如果没有写则读阻塞
若使用文件描述符与有名管道文件进行关联,可实现非阻塞读写,如果没有读,则写不阻塞,如果没有内容则读阻塞
使用read 可以设置读超时,并且读取管道中的值

基于以上原理可以实现Concurrent包下的函数库
# 重定向

# 测试与调试
1. sh -x 
2. 在合适位置 set -x
3. bashdb 单步调试
## 单元测试
以test-开头的都会进行测试
```bash
#!/usr/bin/env bash
# shellcheck disable=SC1091
#################引入需要测试的脚本################
source ./../../BaseShell/Collection/BaseHashMap.sh
###################下面写单元测试#################

###################上面写单元测试#################
source ./../../BaseShell/Utils/BaseTestUtil.sh
```

# 命名风格 
<a name="style"></a>
```
【强制】脚本中变量、函数、文件的命名均不能以数字、下划线、$开头,也不能以下划线或者$结尾
反例: _name / __name / $name / name_ / name$ / 5name
说明: $作为Shell语言的取值符号,其他命名约束参考Java规约。

【强制】代码中的命名严禁使用拼音与英文混合的方式,更不允许直接使用中文的方式。 
正例：alibaba / taobao / youku / hangzhou 等国际通用的名称,可视同英文。
说明：正确的英文拼写和语法可以让阅读者易于理解,避免歧义。注意,即使纯拼音命名方式 也要避免采用。

【强制】参数名、局部变量都统一使用 lowerCamelCase 风格,必须遵从 驼峰形式。
正例： localValue / errMsg / userName

【推荐】使用下划线分割函数命名,都统一使用 lowerCamelCase 风格,必须遵从 驼峰形式。
正例：getUserName() / log_info() / map_add()
说明: 纯用下划线会使得命名很长,纯用驼峰又无法将函数聚类 
get_user_english_name()  vs getUserEnglishName()
log_info() vs logInfo()
map_add() vs mapAdd()

`log_info "xxx"` 在调用的时候类比于Java 的`log.info("xxx")` 

【强制】文件名 UpperCamelCase 风格,首字母大写的驼峰形式
正例：BaseLog.sh / BaseString.sh 

说明：类比Java的类,我们把相同功能的函数抽象到一个脚本文件中,留待后续其他脚本引用。随着我们写的脚本日渐增多
我们很有必要分门别类的将它们聚集到一个文本文件中,一是方便后续查阅,而是方便后续调用

【强制】常量命名全部大写,单词间用下划线隔开,力求语义表达完整清楚,不要嫌名字长。
正例：MAX_STOCK_COUNT 反例：MAX_COUNT

【推荐】文件夹名字大写
【强制】文件名以 .sh 结尾
说明：虽然不用.sh结尾或者以任何其他新式结尾都可以运行,但是以 .sh结尾可以一眼看出就是脚本文件
```
<a name="end"></a>
```
【强制】使用两个空格进行缩进,不适用tab缩进
【推荐】不在一行的时候使用 `\` 进行换行,使用 `\` 换行的原则是整齐美观
```
例子:
```bash
#!/usr/bin/env bash
# 脚本使用帮助文档 []<-()
manual(){
  cat "$0"|grep -v "less \"\$0\"" \
          |grep -B1 "function "   \
          |grep -v "\\--"         \
          |sed "s/function //g"   \
          |sed "s/(){//g"         \
          |sed "s/#//g"           \
          |sed 'N;s/\n/ /'        \
          |column -t              \
          |awk '{print $1,$3,$2}' \
          |column -t
}
function search_user_info(){
  local result=$(httpclient_get --cookie "${cookie}" \
                                         "${url}/userName=${user_name}")
}
```

