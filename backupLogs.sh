#!/bin/bash

. "${HOME}/botScripts/sourceCFG.sh"

BOT=$1
SUFFIX=$2

BOT_PATH="${BOT_ROOT}/${BOT}"

# yep
backupDir=$(date +'%m:%d:%YT%H:%M:%S')

pushd $BOT_PATH

[ ! -d "./oldLogs" ] && mkdir "./oldLogs"
[ ! -d "./oldLogs/${backupDir}_${SUFFIX}" ] && mkdir "./oldLogs/${backupDir}_${SUFFIX}"

mv "./logs/combined.log" "./logs/error.log" "./logs/stdout.log" "./oldLogs/${backupDir}_${SUFFIX}"

touch "./logs/error.log" && \
touch "./logs/stdout.log" && \
touch "./logs/combined.log"

popd
