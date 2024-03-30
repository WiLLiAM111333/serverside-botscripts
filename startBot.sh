#!/bin/bash

. "${HOME}/botScripts/sourceCFG.sh"

BOT=$1
BOT_PATH="${BOT_ROOT}/${BOT}"

if [ -d $BOT_PATH ]; then
  pushd $BOT_PATH

  pm2 start ./index.js \
    --name $BOT \
    --max-memory-restart "150M" \
    --log "./logs/combined.log" \
    --output "./logs/stdout.log" \
    --error "./logs/stderror.log" \
    --no-autorestart \
    --time

  popd
fi
