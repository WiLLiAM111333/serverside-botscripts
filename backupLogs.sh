#!/bin/bash

BOT=$1
SUFFIX=$2

# yep
backupDir=$(date +'%m:%d:%YT%H:%M:%S')

pushd "${HOME}/bots/${BOT}"

[ ! -d "./oldLogs" ] && mkdir "./oldLogs"
[ ! -d "./oldLogs/${backupDir}_${SUFFIX}" ] && mkdir "./oldLogs/${backupDir}_${SUFFIX}"

mv "./logs/combined.log" "./logs/error.log" "./logs/stdout.log" "./oldLogs/${backupDir}_${SUFFIX}"

touch "./logs/error.log" && \
touch "./logs/stdout.log" && \
touch "./logs/combined.log"

popd
