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

## 初始化项目
```
cd ~
mkdir script && cd script #新建一个script目录用于存放所有的脚本
git clone https://github.com/chen-shang/BaseShell.git
sh $(pwd)/BaseShell/init.sh
```
根据提示输入 project[项目目录] 和 module[模块名称]
看到如下输出,则新建项目成功
```
> sh $(pwd)/BaseShell/init.sh
project[项目目录]:com.chenshang.learn
module[模块名称]:Script
./../../com.chenshang.learn
├── BaseShell -> /script/BaseShell
└── Script
    ├── Resources
    ├── Service
    │   └── Main.sh
    ├── Test
    ├── config.sh
    └── readme.md

5 directories, 3 files
```
## 运行项目
【强制】运行shell脚本要到脚本目录下执行
```
cd com.chenshang.learn/Shell/Service/ShellService.sh
sh ShellService.sh
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
./../../com.chenshang.learn
├── BaseShell -> /Users/chenshang/script/BaseShell BaseShell的源码软链
└── Shell
    ├── Resources            资源文件
    ├── Service              项目脚本
    │   └── Main.sh          脚本文件
    ├── Test                 测试脚本
    ├── config.sh            配置文件
    └── readme.md            描述文件
```
BaseShell相当于Java的JDK.
资源文件: 一般放一些文本文件、图片、csv等非脚本文件
项目脚本: 项目相关脚本所在的文件,如果想要写一些辅助的脚本,建议与Service同级创建一个文件夹来写
测试脚本: 对一些赋值函数进行单元测试的脚本文件
配置文件: 项目的配置文件包括 头图、日志级别等以及一些项目中用到的配置项
【推荐】config.sh 脚本中尽量之定义变量,不要定义函数或可执行命令,类比Java项目中的properties
描述文件: 项目的描述文件

# 功能介绍
脚本应该怎么写-示例
```bash
#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
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
【推荐】首行写法 `#!/usr/bin/env bash`
 对应上面示例脚本第一行
2. shellcheck 忽略
【强制】写好脚本后,使用shellcheck进行语法检查,对于忽略的检查项在第二行disable
 对应上面第二行
3. 防止循环引用代码段
 对应3-7行。
```
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
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

未完待续。。。明天再写
