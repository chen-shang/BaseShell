#!/usr/bin/env bash
# shellcheck disable=SC1091
#===============================================================
source ./../../BaseShell/Starter/BaseTestHeader.sh
#===============================================================
source ./../../BaseShell/Log/BaseLog.sh
#===============================================================
test-log(){
  log_info "$(echo "{\"one\":1}"|jq .)"

  log_debug "$(echo "{\"one\":1}"|jq .)"

  log_error "$(echo "{\"one\":1}"|jq .)"

  log_success "$(echo "{\"one\":1}"|jq .)"

  log_warn "$(echo "{\"one\":1}"|jq .)"

  log_trace "$(echo "{\"one\":1}"|jq .)"

  log_fail "$(echo "{\"one\":1}"|jq .)"

  log_info "$(echo "{\"one\":1}"|jq .)"
}
#===============================================================
source ./../../BaseShell/Starter/BaseTestEnd.sh
