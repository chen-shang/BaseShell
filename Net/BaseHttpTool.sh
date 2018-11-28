#!/usr/bin/env bash
source ./../../BashShell/Utils/BaseHeader.sh

function http_get() {
  curl -s -X GET "$@"
}

function http_post() {
  curl -s -X POST "$@"
}

function http_delete() {
  curl -s -X DELETE "$@"

}

function http_put() {
  curl -s -X PUT "$@"
}

# 获取公网IP [String]<-()
function http_public_ip(){
  httpclient_get "http://members.3322.org/dyndns/getip"
}