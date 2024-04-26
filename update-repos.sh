#!/bin/bash

function process_lines() {
  while IFS= read -r string; do
    "$1" "$string"
  done
}

function process_repo() {
  repo="$1"
  if [ "$repo" == "." ]; then
    return
  fi

  echo "$repo"
  cd "$repo"
  git pull --all
  original_branch="$(git rev-parse --abbrev-ref HEAD)"
  git branch -l -a | process_lines process_branch_name | uniq -u | process_lines process_branch
  git tag -l | process_lines process_branch_name | uniq -u | process_lines process_tag
  git checkout "$original_branch"
  git submodule update --recursive
  cd "../"
}

function process_branch_name() {
  branch="$1"
  # Remove leading * for currently checked out branch
  branch="${branch#\*}"
  # Remove leading whitespace
  branch="${branch#"${branch%%[![:space:]]*}"}"
  # Remove trailing whitespace
  branch="${branch%"${branch##*[![:space:]]}"}"
  # Remove remote tag
  branch="${branch#remotes/origin/}"

  # Skip HEAD line
  if [[ "$branch" == "HEAD -> "* ]]; then
    return
  fi

  # Write branch to std out
  echo "$branch"
}

function process_branch() {
  git checkout "$1"
  git pull --recurse-submodules
}

function process_tag() {
  git checkout "$1"
  git submodule update --recursive
}

find -maxdepth 1 -type d | process_lines process_repo
