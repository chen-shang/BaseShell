#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2155
source ./../../BaseShell/Utils/BaseTestHeader.sh
#################引入需要测试的脚本################
source ./../../BaseShell/Lang/BaseString.sh
###################下面写单元测试#################
test-length(){ #ignore
  local result=$(length "123")
  assertEquals "${result}" "3"
  local result=$(echo "123"|length)
  assertEquals "${result}" "3"

  local result=$(length "")
  assertEquals "${result}" "0"
  local result=$(echo ""|length)
  assertEquals "${result}" "0"

  local result=$(length "  ")
  assertEquals "${result}" "2"
  local result=$(echo "  "|length)
  assertEquals "${result}" "2"

  local result=$(length " 123 ")
  assertEquals "${result}" "5"
  local result=$(echo " 123 "|length)
  assertEquals "${result}" "5"

  local result=$(length "123" "134")
  assertEquals "${result}" "7"
  local result=$(echo "123" "134"|length)
  assertEquals "${result}" "7"

}
test-trim(){ #ignore
  local result=$(trim "  1 ")
  assertEquals "${result}" "1"
  local result=$(trim "  1 2 ")
  assertEquals "${result}" "1 2"
  local result=$(echo "  1 "|trim)
  assertEquals "${result}" "1"
  local result=$(echo "  1 2 "|trim)
  assertEquals "${result}" "1 2"
}
test-toUpperCase(){ #ignore
  local result=$(toUpperCase "a")
  assertEquals "${result}" "A"
  local result=$(echo "a"|toUpperCase)
  assertEquals "${result}" "A"
}
test-toLowerCase(){ #ignore
  local result=$(toLowerCase "A")
  assertEquals "${result}" "a"
  local result=$(echo "A"|toLowerCase)
  assertEquals "${result}" "a"
}
test-string_equals(){ #ignore
:
}
test-string_notEquals(){ #ignore
:
}
test-string_equalsIgnoreCase(){ #ignore
:
}
test-string_join(){ #ignore
:
}
test-string_startsWith(){ #ignore
:
}
test-string_endsWith(){ #ignore
:
}
test-string_contains(){ #ignore
:
}
test-string_isNatural(){ #ignore
:
}
test-string_indexOf(){ #ignore
:
}
test-string_lastIndexOf(){ #ignore
:
}
test-string_subString(){ #ignore
:
}
#===============================================================================
source ./../../BaseShell/Utils/BaseTestEnd.sh
