#!/bin/bash

# CLI tool designed to help with managing bots in a production environment.
# This tool can create new bot projects, update an existing bot project as well as reading and backing up logs.

SOURCED=0

# Makes a naive attempt to source the config file
# $1: config file path
SOURCE_CFG() { source $1 && unset $SOURCED && SOURCED=1; }

# Sets the fileselector glob to include hidden files (dotfiles)
shopt -s dotglob

for FILE in *; do
  if [[ -d $FILE && $FILE == "botScripts" ]]; then
    for NESTED_FILE in *; do
      if  [[ -f $NESTED_FILE && $NESTED_FILE == ".cfg" ]]; then
        SOURCE_CFG "${PWD}/${NESTED_FILE}" && break
      fi
    done
  fi

  if [[ -f $FILE && $FILE == ".cfg" ]]; then
    SOURCE_CFG "${PWD}/${NESTED_FILE}" && break
  fi
done

if [ $SOURCED -eq 0 ]; then
  echo "Failed to source config file" && exit 1
fi

BOT=$1
QUERY=$2

BOT_PATH="${BOT_ROOT}/${BOT}"

if [[ $QUERY == "update" && -d $BOT_PATH ]]; then
  # eval $(ssh-agent -s)
  # eval $(ssh-add "${HOME}/.ssh/${GITHUB_SSH_FILENAME}")

  # pm2 "stop" $BOT

  # pushd $BOT_PATH

  # rm -rf "./node_modules"
  # echo "Deleted node_modules"
  # rm -rf -v "./dist"
  # rm -rf -v "package-lock.json"

  # git clone --depth 1 --branch master "https://github.com/${GITHUB_USERNAME}/${BOT}.git" ./update

  # pushd "./update"

  # Replace all old files
  # for FILE in *; do
    # NEW_PATH="../${FILE}"

    # File exists
    # if [ -f $NEW_PATH ]; then
      # rm -f -v $NEW_PATH
    # fi

    # Directory exists
    # if [ -d $NEW_PATH ]; then
      # rm -rf -v $NEW_PATH
    # fi

    # mv $FILE $NEW_PATH
  # done

  # popd

  # Install dependencies
  # npm i

  # if [ -f "./tsconfig.json" ]; then
    # Make sure the TypeScript compiler has access to the latest native node types before compiling
    # npm i -D @types/node
    # tsc
  # fi

  # pushd "./dist"

  # Clean out all unused TypeScript code
  # for FILE in *; do
    # NEW_PATH="../${FILE}"

    # Directory exists
    # if [ -d $NEW_PATH ]; then
      # rm -rf -v $NEW_PATH
    # fi
  # done

  # popd

  # Clean out the messy bullshit
  # rm -rf -v "./update"
  # rm -rf -v "./tools"
  # rm -f -v "./tsconfig.json"
  # rm -f -v "./package.json"
  # rm -f -v "./package-lock.json"
  # rm -f -v "./index.d.ts"
  # rm -f -v "./README.md"
  # rm -f -v "./LICENSE"
  # rm -f -v "./.gitignore"
  # rm -f -v "./.editorconfig"

  # popd

  # ssh-agent -k

  # Shit language
  # bash "${BOTSCRIPTS_ROOT}/backupLogs.sh" $BOT "update"
  # bash "${BOTSCRIPTS_ROOT}/startBot.sh" $BOT
fi
