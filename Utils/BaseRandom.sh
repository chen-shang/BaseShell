#!/usr/bin/env bash
# shellcheck disable=SC1091
source ./../../BaseShell/Utils/BaseHeader.sh

# 这串代码特别简单，就是利用RANDOM这个随机数生成器进行取余就能够实现，至于为什么取余时需要+1是因为在取余时如果被整除那么余数会是0，这样就不在限定范围内了
# seed: 种子
# []->(seed:int)
function random_next(){
  local seed=$1
  echo $((RANDOM%seed+1))
}

function random_string(){
  head -c 5 /dev/random |base32
}