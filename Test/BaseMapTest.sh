#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Collection/BaseMap.sh
#===============================================================
test-map(){ #ignore
  map_put "one" "1"
  map_put "two" "2"
  map_put "three" "3"
  map_put "four" "4"

  map_get "one"
  map_containsKey "one" && echo "包含one" || echo "不包含one"
  map_containsKey "five" && echo "包含five" || echo "不包含five"
  map_size
  map_remove "one"
  map_containsKey "one" && echo "包含one" || echo "不包含one"

  map_containsValue 1  && echo "contains" || echo "! contains"
  map_containsValue 2  && echo "contains" || echo "! contains"

  map_size
  map_keys
  map_values

  map_entrySet

  map_forEach log
}

log(){
  k=$1
  v=$2
  log_debug "[${LINENO}]: ${k}=${v}"
}

test-new_map(){
  declare -A qq=()
  new_map qq
#  qq_put "one" "1"
#  qq_put "two" "2"
#  qq_put "three" "3"
#  qq_forEach log
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
