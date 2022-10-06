#!/bin/bash

# CLI tool designed to help with managing bots in a production environment.
# This tool can create new bot projects, update an existing bot project as well as reading and backing up logs.

BOT=$1
QUERY=$2

BOT_PATH="${HOME}/bots/${BOT}"
BOT_SCRIPTS_PATH="${HOME}/botScripts"

if [[ $QUERY == "update" && -d $BOT_PATH ]]; then
  pm2 "stop" $BOT

  # SSH magic
  eval $(ssh-agent -s)
  ssh-add "${HOME}/.ssh/git"

  pushd $BOT_PATH

  rm -rf -v "./node_modules"
  rm -rf -v "./dist"
  rm -rf -v "package-lock.json"

  git clone --depth 1 --branch master "git@github.com:WiLLiAM111333/${BOT}.git" ./update

  pushd "./update"

  # Replace all old files
  for FILE in *; do
    NEW_PATH="../${FILE}"

    # File exists
    if [ -f $NEW_PATH ]; then
      rm -f -v $NEW_PATH
    fi

    # Directory exists
    if [ -d $NEW_PATH ]; then
      rm -rf -v $NEW_PATH
    fi

    mv $FILE $NEW_PATH
  done

  popd

  # Install dependencies
  npm i

  if [ -f "./tsconfig.json" ]; then
    # Make sure the TypeScript compiler has access to the latest native node types before compiling
    npm i -D @types/node
    tsc
  fi

  pushd "./dist"

  # Clean out all unused TypeScript code
  for FILE in *; do
    NEW_PATH="../${FILE}"

    # Directory exists
    if [ -d $NEW_PATH ]; then
      rm -rf -v $NEW_PATH
    fi
  done

  popd

  # Clean out the messy bullshit
  rm -rf -v "./update"
  rm -rf -v "./tools"
  rm -f -v "./tsconfig.json"
  rm -f -v "./package.json"
  rm -f -v "./package-lock.json"
  rm -f -v "./index.d.ts"
  rm -f -v "./README.md"
  rm -f -v "./LICENSE"
  rm -f -v "./.gitignore"
  rm -f -v "./.editorconfig"

  popd

  # Shit language
  bash "${BOT_SCRIPTS_PATH}/backupLogs.sh" $BOT "update"
  bash "${BOT_SCRIPTS_PATH}/startBot.sh" $BOT

  # No more SSH magic
  eval $(ssh-agent -k)
elif [[ $QUERY == "start" && -d $BOT_PATH ]]; then
  bash "${BOT_SCRIPTS_PATH}/startBot.sh" $BOT
elif [[ $QUERY == "log" && -d $BOT_PATH ]]; then
  LOG_PATH="${BOT_PATH}/logs"

  # Displays line numbers
  CAT_OPTIONS="-n"

  SUB_QUERY=$3
  DEEPER_QUERY=$4

  if [[ $SUB_QUERY == "read" ]]; then
    # Clear console for better readability
    clear

    # Read combined file if there is no other file provided as $4
    # Else read only if $4 is the name of a file in the logs directory (stdout, error or combined)
    if [[ $DEEPER_QUERY == "" ]]; then
      cat $CAT_OPTIONS "${LOG_PATH}/combined.log";
    else if [ -f "${LOG_PATH}/${DEEPER_QUERY}.log" ]; then
      cat $CAT_OPTIONS "${LOG_PATH}/${SUB_QUERY}.log"
    else
      echo "${DEEPER_QUERY}.log is not a file in the log directory" && exit 1
    fi
	fi

  # Illegal activities happen in this place
	elif [[ $SUB_QUERY == "backup" ]]; then
    # Default the suffix to "backup" if there is no $4
    if [[ $DEEPER_QUERY == "" ]]; then
      bash "${BOT_SCRIPTS_PATH}/backupLogs.sh" $BOT "backup"
    else
      bash "${BOT_SCRIPTS_PATH}/backupLogs.sh" $BOT $DEEPER_QUERY
    fi

  # Deletes and replaces the log files
  elif [[ $SUB_QUERY == "delete" ]]; then
    rm -rf $LOG_PATH
    mkdir $LOG_PATH && \
      touch "${LOG_PATH}/error.log" && \
      touch "${LOG_PATH}/stdout.log" && \
      touch "${LOG_PATH}/combined.log"
  fi

  # Creates a new bot folder in /home/william/bots with a git URL as $3
elif [[ $QUERY == "create" && ! -d $BOT_PATH ]]; then
  mkdir $BOT_PATH
  pushd $BOT_PATH

  GIT_URL="git@github.com:WiLLiAM111333/${BOT}.git"

  git init
  git remote add bot $GIT_URL && echo "Added remote 'bot' at '${GIT_URL}'"

  mkdir "./logs" && \
    touch "./logs/error.log" && \
    touch "./logs/stdout.log" && \
    touch "./logs/combined.log"
  mkdir oldLogs

  popd
fi
