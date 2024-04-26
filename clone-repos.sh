#!/bin/bash

function process_lines() {
  while IFS= read -r string; do
    "$1" $string
  done
}

function clone() {
  echo "$1"
  if [ -n "$2" ]; then 
    git clone "$1" "$2" --recurse-submodules
  else
    git clone "$1" --recurse-submodules
  fi
}

cat ./repos.list | process_lines clone
bash "$(dirname $0)/update-repos.sh"
