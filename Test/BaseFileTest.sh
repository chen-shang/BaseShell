#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
#===============================================================
source ./../../BaseShell/Starter/BaseHeader.sh
#===============================================================
source ./../../BaseShell/File/BaseFile.sh
#===============================================================
file='./file'
test-file(){
  local lines=$(file_read "${file}"|limit 10|wc -l)
  assertEquals ${lines} 10

  local header=$(file_header "${file}")
  assertEquals "${header}" "# Copyright (c) 2017-2018, googlehosts members."
  local header=$(file_read "${file}"|file_header)
  assertEquals "${header}" "# Copyright (c) 2017-2018, googlehosts members."


  local tailer=$(file_tailer "${file}")
  assertEquals "${tailer}" "# Modified Hosts End"
  local tailer=$(file_read "${file}"|file_tailer)
  assertEquals "${tailer}" "# Modified Hosts End"


  local line=$(file_line 2 "${file}")
  assertEquals "${line}" "# https://github.com/googlehosts/hosts"
  local line=$(file_read "${file}"|file_line 2)
  assertEquals "${line}" "# https://github.com/googlehosts/hosts"

  file_getLines "${file}"
  file_getName "${file}"
  file_getPath "${file}"
  file_getSize "${file}"

  file_canRead "${file}" && echo 0 || echo 1
  file_canWrite "${file}" && echo 0 || echo 1
  file_canExecute "${file}" && echo 0 || echo 1
  file_isFile "${file}" && echo 0 || echo 1
  file_isDir "${file}" && echo 0 || echo 1
  file_isExist "${file}" && echo 0 || echo 1
  echo "===="
  cat ./table |transpose
  transpose ./table
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
