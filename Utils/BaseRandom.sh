#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseImported.sh && return
#===============================================================

# 这串代码特别简单，就是利用RANDOM这个随机数生成器进行取余就能够实现，至于为什么取余时需要+1是因为在取余时如果被整除那么余数会是0，这样就不在限定范围内了
# RANDOM 0~32767 之间的一个整数
# seed: 种子,随机数有可能等于seed
# 产生一个随机数 []->(seed:int)
function random_int(){
  local seed=${1:-65536}
  echo $((RANDOM%seed))
}

# 产生一个随机未字符串 base32
function random_string(){
  local length=${1:-16}
  head -c ${length} /dev/random |base32
}

# 产生随机一句话
function random_word(){
  #木芽一言 https://api.xygeng.cn/dailywd/?pageNum=320
  curl -s https://api.xygeng.cn/dailywd/api/|jq -r .txt |xargs echo
  #一言 https://hitokoto.cn/api
}

# 产生随机一首诗词
function random_poetry(){
   curl -s -H 'X-User-Token:RgU1rBKtLym/MhhYIXs42WNoqLyZeXY3EkAcDNrcfKkzj8ILIsAP1Hx0NGhdOO1I' https://v2.jinrishici.com/sentence|jq .data.origin|xargs echo
}
