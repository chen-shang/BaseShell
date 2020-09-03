```
 ____                      _          _ _
| __ )  __ _ ___  ___  ___| |__   ___| | |
|  _ \ / _` / __|/ _ \/ __| '_ \ / _ \ | |
| |_) | (_| \__ \  __/\__ \ | | |  __/ | |
|____/ \__,_|___/\___||___/_| |_|\___|_|_|
```

![](https://github.com/chen-shang/Picture/blob/master/init.gif)

请预先安装以下工具
```
column 、lolcat、tree、jq、gdate
```
所有脚本均系mac环境开发,使用的是bash,理论上兼容所有linux系统,如遇问题,请联系我,我来做兼容
![](https://github.com/chen-shang/Picture/blob/master/weixin/WechatIMG99.jpeg)

# BaseShell使用教程
[BaseShell使用教程](https://chen-shang.github.io/2019/08/28/ji-zhu-zong-jie/baseshell/baseshell-shi-yong-jiao-cheng/)

我写这套框架的初衷在于丰富自己的shell脚本库，以期在写一些简单脚本辅助开发时候能够像使用Java类库一样方便。同时为了写出类似Java的工具类，这会强迫自己深入学习Java的源代码。

所以Java是我的第一语言,Scala作为第二语言,忠实的shell粉,但不排斥其他编程语言。这是我对编程语言的态度。

BaseShell类似于Java语言的SDK是为Shell脚本语言提供的一套工具库,涵盖多种**类**Java工具的实现
```
.
├── Annotation                         #函数参数校验脚本
|   └── BaseAnnotation.sh
├── Collection                         #集合处理脚本
|   ├── BaseArrayList.sh
|   ├── BaseHasMap.sh
|   └── BaseMap.sh
├── Concurrent                         #并发控制脚本
|   ├── BaseLock.sh
|   ├── BaseThreadPool.sh
|   └── BaseThreadPoolExecutor.sh
├── Constant                           #自定义常量
|   └── BaseConstant.sh
├── Date                               #日期处理脚本
|   ├── BaseLocalDate.sh
|   ├── BaseLocalDateTime.sh
|   ├── BaseLocalTime.sh
|   ├── BaseMonth.sh
|   ├── BaseTimeUnit.sh
|   ├── BaseTimestamp.sh
|   └── BaseWeek.sh
├── File                               #文件处理脚本
|   ├── BaseFile.sh
|   └── BaseTable.sh
│   └── BaseTableGen.sh
├── Json
│   └── BaseJson.sh                    #Json工具类
├── Cursor                             #光标控制脚本
│   ├── BaseCursor.sh
│   ├── BaseKeyboard.sh
│   └── BaseKeyboardEvent.sh
├── Lang  
|   ├── BaseMath.sh
|   ├── BaseObject.sh
|   └── BaseString.sh
├── Log                                #日志脚本
|   └── BaseLog.sh
├── Ssh #ssh工机具
|   └── BaseSsh.sh
├── Starter                            #包导入辅助脚本
|   ├── BaseDateTimeStarter.sh
|   ├── BaseEnd.sh
|   ├── BaseHeader.sh
|   ├── BaseStarter.sh
|   ├── BaseTestEnd.sh
|   └── BaseTestHeader.sh
├── Test                              #单元测试脚本
|   ├── BaseAnnotationTest.sh
├── Utils                              #辅助工具脚本
|   ├── BaseCodec.sh
|   ├── BaseRandom.sh
|   └── BaseUuid.sh
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
mkdir Shell && cd Shell #新建一个script目录用于存放所有的脚本
git clone https://github.com/chen-shang/BaseShell.git
sh $(pwd)/BaseShell/init.sh
```
根据提示输入 project:项目目录 和 module:模块名称
看到如下输出,则新建项目成功
```
> sh $(pwd)/BaseShell/init.sh
project[项目目录]:com.baseshell.learn
module[模块名称]:Script
./../../com.baseshell.learn
├── BaseShell -> /Users/chenshang/Shell/BaseShell
└── Script
    ├── Controller
    │   └── Main.sh
    ├── Profile
    │   ├── dev
    │   │   └── application.sh
    │   └── prod
    │       └── application.sh
    ├── Resources
    ├── Service
    │   └── DemoService.sh
    ├── Test
    │   └── DemoServiceTest.sh
    ├── Utils
    ├── config.sh
    └── readme.md

10 directories, 7 files
```
## 运行项目
【强制】运行shell脚本要cd到脚本所在目录下执行
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
project[项目目录]:com.baseshell.learn
module[模块名称]:Script
./../../com.baseshell.learn                             项目目录
├── BaseShell -> /Users/chenshang/Shell/BaseShell       BaseShell的源码软链,相当于类库
└── Script                                              模块目录：一般建议大写,代表一个Shell模块,里面专门是针对某个模块儿的脚本
    ├── Controller                                      Controller：类似MVC模式中的Controller层,是脚本的入口
    │   └── Main.sh
    ├── Profile                                         配置文件：类似Maven中的Profile，在config.sh中通过env控制选择加载哪个环境的配置文件。默认dev和prod两个环境
    │   ├── dev
    │   │   └── application.sh
    │   └── prod
    │       └── application.sh
    ├── Resources                                       资源目录：资源目录: 一般放一些文本文件、图片、csv等非脚本文件
    ├── Service                                         项目目录：项目相关脚本所在的文件,如果想要写一些辅助的脚本,建议与Service同级创建一个文件夹来写
    │   └── DemoService.sh
    ├── Test                                            测试目录：对脚本中的函数进行单元测试的脚本
    │   └── DemoServiceTest.sh
    ├── Utils                                           工具目录：工具类
    ├── config.sh                                       配置文件：项目的配置文件包括 头图、日志级别等以及一些项目中用到的配置项
    └── readme.md                                       描述文件：项目名称、项目介绍等等

10 directories, 7 files
```
BaseShell相当于Java的JDK.

【推荐】config.sh 脚本中尽量之定义变量,不要定义函数或可执行命令,类比Java项目中的properties
【推荐】application.sh 针对不同环境有不同的配置的,可以写到application.sh中,可以在这里定义函数

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

因此

【强制】在一个项目中,不要存在同名文件

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
因此

【强制】`source ./../../BaseShell/Starter/BaseHeader.sh`,`source ./../config.sh`这两个是必须要引用的,且放在所有引用的开头。

5. 接下来是main入口函数和业务代码

【推荐】Service包中的业务代码都推荐写入main

6. 写在最后
```
#===============================================================================
source ../../BaseShell/Starter/BaseEnd.sh
```
这样直接执行脚本的时候,会先寻找脚本里面的main函数去执行,类似运行一个Java Class类中的main方法

【强制】Service包中的业务代码都必须引入 `source ../../BaseShell/Starter/BaseEnd.sh`

【强制】自定义的工具脚本不要引入 `source ../../BaseShell/Starter/BaseEnd.sh`

## 如何引用包
我们规定项目目录最大深度为2层,也就是不允许在Service同级的目录下在创建目录然后在里面写脚本

引用包使用source命令
`source xx.sh`会使第三方脚本xx.sh从头到尾加载一遍,遇到函数就加载函数、遇到变量就加载变量、遇到可执行的命令就会执行,这个命令其实就是把第三方脚本定义的函数、全局变量加载到当前脚本的上下文中
这里推荐使用相对路径,因为使用绝对路径,IDEA无法进行代码提示,也是醉了

示例
如果想引入日期相关的函数 `source ./../../BaseShell/Date/BaseLocalDate.sh`

如果想引入文件相关的函数 `source ./../../BaseShell/File/BaseFile.sh`

### 函数参数校验脚本【Annotation】
```
.
├── Annotation                         #函数参数校验脚本
|   └── BaseAnnotation.sh
```
默认自动引入,此包下的工具是用来进行函数参数校验的,类似Spring中的Validate的功能。一旦参数校验没有通过则会终止函数的执行。 所有方法都是以 `_` 开头的,类似于Java中的`@`
曾想用@开头,但发现@在shell中属于特殊字符,不允许出现在函数命中,斟酌再三选择了`_`

| 方法      | 表头                       | 备注 |
|:----------|:---------------------------|:-----|
| _NotBlank | 入参数不为空(空或空字符串) | -    |
| _Natural  | 入参数为自然数(0,1,2,3...) | -    |
| _Min      | 最大不得小于此最小值       | -    |
| _Max      | 最大不得超过此最大值       | -    |

基本套路是,第一个参数是变量,第二个参数是异常时候的代码提示

示例
```bash
# ssh连接
function ssh_connect(){ _NotBlank "$1" "ip can not be null" && _NotBlank "$2" "port can not be null" && _NotBlank "$3" "user can not bull" && _NotBlank "$4" "pass can not bull"
  local ip=$1 ;local port=$2 ;local user=$3 ;local pass=$4
}
```
一般函数的参数校验,我一般和函数写在一行上,第二行用具体的变量名接收参数。上面的函数如果有某个参数没有传,函数会异常退出,下面的代码也不会执行。

![](https://github.com/chen-shang/Picture/blob/master/baseshell/annotation.jpg)

## 集合处理脚本【Collection】
```
├── Collection
|   ├── BaseArrayList.sh
|   ├── BaseHasMap.sh 
|   └── BaseMap.sh
```
此包下的工具是用来对集合 和 Map 进行操作的。
### BaseArrayList.sh
| 方法               | 说明                                 | 备注           |
|:-------------------|:---------------------------------------|:---------------|
| new_arrayList      | 新建一个list                           | -              |
| list_add           | 添加元素                               | -              |
| list_set           | 设置元素                               | -              |
| list_removeByIndex | 按照下标移除元素                       | -              |
| list_removeByValue | 按照值移除元素                         | -              |
| list_get           | 按照下标获取元素                       | -              |
| list_forEach       | 对列表中的每一个元素都进行操作         | -              |
| list_size          | 获取当前list的元素个数                 | -              |
| list_isEmpty       | 判断当前list是否为空                   | -              |
| list_contains      | 判断当前list是否包含某元素             | -              |
| list_clear         | 清空当前list                           | -              |
| list_indexOf       | 获取指定元素的下标                     | 从前往后第一个 |
| list_lastIndexOf   | 获取指定元素的下标                     | 从后往前第一个 |
| list_sub           | 截取指定下标的元素                     | -              |
| list_copy          | 赋值一个新的数组                       | -              |
| list_values        | 获取元素的值列表                       | -              |
| list_mapper        | 最每一个元素进行操作并返回一个新的列表 | -              |
| list_reducer       | 聚类操作                               | -              |
### BaseHasMap.sh
### BaseMap.sh
## 日志工具【Log】
### 如何引入
`source ./../../BaseShell/Starter/BaseHeader.sh` 默认会引入Log框架 `source ./../../BaseShell/Log/BaseLog.sh` 无需手动引入

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
![](https://github.com/chen-shang/Picture/blob/master/Log.gif)
未完待续。。。明天再写
## 并发工具【Concurrent】
## 锁【Concurrent】
## Object工具【Lang】
## 数学工具【Lang】
| 方法          | 说明           |
|---------------|----------------|
| math_abs      | 求绝对值       |
| math_toDeci   | 转十进制       |
| math_toBinary | 转二进制       |
| math_toHex    | 转十六进       |
| math_max      | 两数中的最大值 |
| math_min      | 两数中的最小值 |
| math_sqrt     | 开方           |
| math_avg      | 均值           |
| math_log      | 对数           |

![](https://github.com/chen-shang/Picture/blob/master/baseshell/math.gif)
## 常量【Constant】
几个常量定义如下,可以在脚本的任何位置使用,因为太常用了,尤其是 `TRUE` `FALSE`
```
#===============================================================
readonly TRUE=0                         # Linux 中一般0代表真非0代表假
readonly FALSE=1
readonly NONE=''
readonly NULL='null'
readonly PI=3.14159265358979323846
readonly E=2.7182818284590452354
```
## 字符串工具【Lang】
## SSH【Ssh】
## Starter包【Starter】
## 工具包【Utils】
### BaseRandom.sh
| 方法          | 说明                          | 备注 |
|:--------------|:------------------------------|:-----|
| random_int    | 产生一个随机数                | -    |
| random_string | # 产生一个随机未字符串 base32 | -    |
| random_word   | 产生随机一句话                | -    |
| random_poetry | 产生随机一首诗词              | -    |

### BaseUuid.sh
| 方法  | 说明        | 备注 |
|:-----|:------------|:----|
| uuid | 返回一个uuid |     |

测试用例
```
#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Utils/BaseUuid.sh
#===============================================================
test-uuid(){
  local uuid=$(uuid)
  assertNotNull "${uuid}"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
```
![](https://github.com/chen-shang/Picture/blob/master/uuid.gif)
## 测试【Utils】
