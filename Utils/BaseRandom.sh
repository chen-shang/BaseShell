#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
import=$(basename "${BASH_SOURCE[0]}" .sh)
if [[ $(eval echo '$'"${import}") == 0 ]]; then return; fi
eval "${import}=0"
#===============================================================
source ./../../BaseShell/Starter/BaseStarter.sh

# 这串代码特别简单，就是利用RANDOM这个随机数生成器进行取余就能够实现，至于为什么取余时需要+1是因为在取余时如果被整除那么余数会是0，这样就不在限定范围内了
# RANDOM 0~32767 之间的一个整数
# seed: 种子
# 产生一个随机数 []->(seed:int)
function random_int(){
  local seed=${1:-65536}
  echo $((RANDOM%seed+1))
}

# 产生一个随机未字符串 base32
function random_string(){
  local length=${1:-16}
  head -c ${length} /dev/random |base32
  # head -c ${length} /dev/urandom |base32
  # openssl rand
}
