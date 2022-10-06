#!/bin/bash

BOT=$1

if [ -d "${HOME}/bots/${BOT}" ]; then
  pushd "${HOME}/bots/${BOT}"

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
