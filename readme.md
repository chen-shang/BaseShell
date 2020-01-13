```
 ____                      _          _ _
| __ )  __ _ ___  ___  ___| |__   ___| | |
|  _ \ / _` / __|/ _ \/ __| '_ \ / _ \ | |
| |_) | (_| \__ \  __/\__ \ | | |  __/ | |
|____/ \__,_|___/\___||___/_| |_|\___|_|_|
```

![](https://github.com/chen-shang/Picture/blob/master/init.gif)

# BaseShell使用教程
[BaseShell使用教程](https://chen-shang.github.io/2019/08/28/ji-zhu-zong-jie/baseshell/baseshell-shi-yong-jiao-cheng/)

我写这套框架的初衷在于丰富自己的shell脚本库，以期在写一些简单脚本辅助开发时候能够像使用Java类库一样方便。同时为了写出类Java的工具类，这会强迫自己深入学习Java的源代码。

所以Java是我的第一语言,Scala作为第二语言,忠实的shell粉,但不排除其他编程语言。这是我对编程语言的态度。

BaseShell类似于Java语言的SDK是为Shell脚本语言提供的一套工具库,涵盖多种类Java工具的实现
```
.
├── Annotation                         #函数参数校验脚本
│   └── BaseAnnotation.sh
├── Collection                         #集合处理脚本
│   ├── BaseArrayList.sh
│   ├── BaseHasMap.sh
│   └── BaseMap.sh
├── Concurrent                         #并发控制脚本
│   ├── BaseLock.sh
│   ├── BaseThreadPool.sh
│   └── BaseThreadPoolExecutor.sh
├── Constant                           #自定义常量
│   └── BaseConstant.sh
├── Date                               #日期处理脚本
│   ├── BaseLocalDate.sh
│   ├── BaseLocalDateTime.sh
│   ├── BaseLocalTime.sh
│   ├── BaseMonth.sh
│   ├── BaseTimeUnit.sh
│   ├── BaseTimestamp.sh
│   └── BaseWeek.sh
├── File                               #文件处理脚本
│   ├── BaseFile.sh
│   └── BaseTable.sh
├── Lang  
│   ├── BaseMath.sh
│   ├── BaseObject.sh
│   └── BaseString.sh
├── Log                                #日志脚本
│   └── BaseLog.sh
├── Ssh #ssh工机具
│   └── BaseSsh.sh
├── Starter                            #包导入辅助脚本
│   ├── BaseDateTimeStarter.sh
│   ├── BaseEnd.sh
│   ├── BaseHeader.sh
│   ├── BaseStarter.sh
│   ├── BaseTestEnd.sh
│   └── BaseTestHeader.sh
├── Test                              #单元测试脚本
│   ├── BaseAnnotationTest.sh
│   ├── BaseArrayListTest.sh
│   ├── BaseLocalDateTest.sh
│   ├── BaseLocalDateTimeTest.sh
│   ├── BaseLocalTimeTest.sh
│   ├── BaseLockTest.sh
│   ├── BaseLogTest.sh
│   ├── BaseMapTest.sh
│   ├── BaseMiniTest.sh
│   ├── BaseObjectTest.sh
│   ├── BaseRandomTest.sh
│   ├── BaseStringTest.sh
│   ├── BaseTableTest.sh
│   ├── BaseThreadPoolExecutorTest.sh
│   ├── BaseThreadPoolTest.sh
│   ├── BaseUuidTest.sh
│   └── table
├── Utils                              #辅助工具脚本
│   ├── BaseCodec.sh
│   ├── BaseRandom.sh
│   └── BaseUuid.sh
├── Banner                             #项目头图
├── config.sh                          #项目配置文件
├── init.sh                            #项目初始化脚本
├── BaseShellMini.sh                   #常用最小引入脚本
└── readme.md                          #项目介绍
```
目前还在完善当中。旨在简化shell脚本的编写、提高shell脚本的健壮性。丰富的脚本库可以大大减少shell脚本编写的难度，其类Java的实现方式可以使得面向对象范式的程序员很快的理解并使用。与之相配套的我会出一篇《Shell编程规约》,以期规范Shell脚本程序员的书写习惯。

## 初始化项目
```
cd ~
mkdir shell && cd shell #新建一个script目录用于存放所有的脚本
git clone https://github.com/chen-shang/BaseShell.git
sh $(pwd)/BaseShell/init.sh
```
根据提示输入 project[项目目录] 和 module[模块名称]
看到如下输出,则新建项目成功
```
> sh $(pwd)/BaseShell/init.sh
project[项目目录]:com.baseshell.learn
module[模块名称]:Script
./../../com.baseshell.learn
├── BaseShell -> /Users/chenshang/shell/BaseShell
└── Script
    ├── Resources
    ├── Service
    │   └── Main.sh
    ├── Test
    ├── Utils
    ├── config.sh
    └── readme.md

6 directories, 3 files
```
## 运行项目
【强制】运行shell脚本要到脚本目录下执行
```
cd com.baseshell.learn/Script/Service/
sh Main.sh
```
看到如下输出,说明项目运行ok,之后可以愉快的写脚本了
```
 ____                 ____  _          _ _
| __ )  __ _ ___  ___/ ___|| |__   ___| | |
|  _ \ / _` / __|/ _ \___ \| '_ \ / _ \ | |
| |_) | (_| \__ \  __/___) | | | |  __/ | |
|____/ \__,_|___/\___|____/|_| |_|\___|_|_|
hello world
```
# 目录结构
```
./../../com.baseshell.learn                         项目目录
├── BaseShell -> /Users/chenshang/shell/BaseShell   BaseShell的源码软链
└── Script                                          模块目录：一般建议大写,代表一个Shell模块,里面专门是针对某个模块儿的脚本
    ├── Resources                                   资源目录：资源目录: 一般放一些文本文件、图片、csv等非脚本文件
    ├── Service                                     项目目录：项目相关脚本所在的文件,如果想要写一些辅助的脚本,建议与Service同级创建一个文件夹来写
    │   └── Main.sh                                 
    ├── Test                                        测试目录：对脚本中的函数进行单元测试的脚本
    ├── Utils                                       工具目录：工具类
    ├── config.sh                                   配置文件：项目的配置文件包括 头图、日志级别等以及一些项目中用到的配置项
    └── readme.md                                   描述文件：项目名称、项目介绍等等
└── Module2                                         模块二

6 directories, 3 files
```

BaseShell相当于Java的JDK.

配置文件:
 
【推荐】config.sh 脚本中尽量之定义变量,不要定义函数或可执行命令,类比Java项目中的properties
描述文件: 项目的描述文件

# 功能介绍
脚本应该怎么写-示例
```bash
#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import="$(basename "${BASH_SOURCE[0]}" .sh)_$$"
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
source ./../config.sh
#导入工具包
#===============================================================================
#业务代码
main(){
  echo "hello world"
}
#===============================================================================
source ../../BaseShell/Starter/BaseEnd.sh
```

1. 解释器声明

对应上面示例脚本第一行

【推荐】首行写法 `#!/usr/bin/env bash`

2. shellcheck 忽略

对应上面示例脚本第二行

【强制】写好脚本后,使用shellcheck进行语法检查

3. 防止循环引用代码段

对应上面示例脚本3-7行

```
#===============================================================
import="$(basename "${BASH_SOURCE[0]}" .sh)_$$"
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
```
这段代码的作用是为了预防 像 A脚本引用B脚本,B脚本又引用A脚本导致的循环引用问题。其原理是以文件名定义一个变量,引用过之后变量的值设置为0,再次引用的时候直接return,注意再次引用的时候是直接return不是exit. 详细用法,后面会有展开。
这段代码目前是我能想到的最精简的方式,不排除以后有更优的方案。

4. 引用各种工具类,类似于Java中的import
```
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
source ./../config.sh
#导入工具包
#===============================================================================
```

引用第三方脚本使用source命令,相当于Java的import关键字
`source ./../../BaseShell/Starter/BaseHeader.sh`,`source ./../config.sh`这两个是必须要引用的,且放在所有引用的开头。
`source ./../config.sh` 则是为了因为当前项目的配置文件,我们对项目的全局配置变量都在这里面定义
`source ./../../BaseShell/Starter/BaseHeader.sh` 目的是引入BaseShell框架. 相当于引用下面四个包
```
source ./../../BaseShell/Lang/BaseObject.sh
source ./../../BaseShell/Log/BaseLog.sh
source ./../../BaseShell/Annotation/BaseAnnotation.sh
source ./../../BaseShell/Lang/BaseString.sh
```

5. 接下来是main入口函数和业务代码

【推荐】Service包中的业务代码都推荐写入main

6. 写在最后
```
#===============================================================================
source ../../BaseShell/Starter/BaseEnd.sh
```
这样直接执行脚本的时候,会先寻找脚本里面的main函数去执行,类似运行一个Java Class类中的main方法

## 如何引用包
引用包使用source命令
`source 第三方脚本`会使第三方脚本从头到尾加载一遍,遇到函数就加载函数、遇到变量就加载变量、遇到可执行的命令就会执行,这个命令其实就是把第三方脚本定义的函数、全局变量加载到当前脚本的上下文中
这里推荐使用相对路径,因为使用绝对路径,IDEA无法进行代码提示,也是醉了

### Annotation #函数参数校验脚本
```
.
└── BaseAnnotation.sh
```
默认自动引入,此包下的工具是用来进行函数参数校验的,类似Spring中的Validate的功能。一旦参数校验没有通过则会终止函数的执行。 所有方法都是以 `_` 开头的,类似于Java中的`@`
曾想用@开头,但发现@在shell中属于特殊字符,不允许出现在函数命中,斟酌再三选择了`_`

|方法|表头|备注|
|:----|:----:|:----:|
|_NotBlank|入参数不为空(空或空字符串)|
|_Natural|入参数为自然数(0,1,2,3...)|
|_Min|最大不得小于此最小值|
|_Max|最大不得超过此最大值|

示例
```bash
# 将文件内容读进内存
function ssh_checkLogin(){ _NotBlank "$1" "ip can not be null" && _NotBlank "$2" "port can not be null" && _NotBlank "$3" "user can not bull" && _NotBlank "$4" "pass can not bull"
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4
}
```
一般函数的参数校验,我一般和函数也在一行上,第二行用具体的变量名接收参数。上面的函数如果有某个参数没有传,函数会异常退出,下面的代码也不会执行。

## 日志工具【Log】
### 如何引入
`source ./../../BaseShell/Starter/BaseHeader.sh`默认会引入Log框架`source ./../../BaseShell/Log/BaseLog.sh` 无需手动引入

### 默认配置
两个系统默认配置,在 `config.sh` 配置文件中,用户可根据自己的意愿修改
```
# 日志记录位置
LOG_DIR="${HOME}/.baseshell"
# 日志级别
LOG_LEVEL=SYSTEM
```
### 使用方法
```
支持固定文本
log_debug "要记录的日志内容"
支持字符串插值
log_debug "要记录的日志内容. key=${key},value=${value}"
支持多参数
log_debug "要记录的日志内容." "1=$1" "2=$2"
支持函数
log_debug "要记录的日志内容." "now=$(date)" "index=$((i++))"
```

Log 包里面有8个方法

| 方法        | 配置文件配置     | 说明                                                              |
|-------------|------------------|-------------------------------------------------------------------|
| log_debug   | LOG_LEVEL=DEBUG  | 打印DEBUG级别的日志                                               |
| log_info    | LOG_LEVEL=INFO   | 打印INFO级别的日志,输出颜色为白色                                 |
| log_success | LOG_LEVEL=INFO   | 打印INFO级别的日志,输出颜色为绿色                                 |
| log_fail    | LOG_LEVEL=INFO   | 打印INFO级别的日志,输出颜色为红色,并退出当前进程                  |
| log_warn    | LOG_LEVEL=WARN   | 打印WARN级别的日志,输出颜色为灰色                                 |
| log_error   | LOG_LEVEL=ERROR  | 打印ERROR级别的日志,输出颜色为红色                                |
| log_system  | LOG_LEVEL=SYSTEM | 打印SYSTEM级别的日志,输出颜色为白色,是BaseShell使用的日志输出格式 |
| log_trace   |                  | 只会记录日志到文件,不会打印到控制台                               |

### 输出示例
执行Test下的测试用例,输出如下
![](BaseShell使用教程/log.jpg)

### 使用示例
![](BaseShell使用教程/Log.gif)

### 使用示例
![](BaseShell使用教程/Log.gif)

未完待续。。。明天再写
## 并发工具【Concurrent】
## 锁【Concurrent】
## Object工具【Lang】
## 数学工具【Lang】
## 常量【Constant】
## 字符串工具【Lang】
## SSH【Ssh】
## Starter包【Starter】
## 工具包【Utils】
## 测试【Utils】