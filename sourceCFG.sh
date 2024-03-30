#!/bin/bash

SOURCED=0

# Makes a naive attempt to source the config file
# $1: config file path
SOURCE_CFG() { source $1 && unset $SOURCED && SOURCED=1; }

# Sets the fileselector glob to include hidden files (dotfiles)
shopt -s dotglob

for FILE in *; do
  if [[ -d $FILE && $FILE == "botScripts" ]]; then
    cd $FILE

    for NESTED_FILE in *; do
      if  [[ -f $NESTED_FILE && $NESTED_FILE == ".cfg" ]]; then
        SOURCE_CFG "${PWD}/${NESTED_FILE}" && break
      fi
    done

    cd ..
  fi

  if [[ -f $FILE && $FILE == ".cfg" ]]; then
    SOURCE_CFG "${PWD}/${NESTED_FILE}" && break
  fi
done

if [ $SOURCED -eq 0 ]; then
  echo "Failed to source config file" && exit 1
fi
