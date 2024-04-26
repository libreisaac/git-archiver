#!/bin/bash

function process_lines() {
  while IFS= read -r string; do
    "$1" "$string"
  done
}

function clone() {
  echo "$1"
  git clone "$1" --recurse-submodules
}

cat ./repos.list | process_lines clone
bash "$(dirname $0)/update-repos.sh"
