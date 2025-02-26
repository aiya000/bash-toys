#!/bin/bash

source ./source-all.sh

for test_file in ./test/*.bats ; do
  echo
  echo "Running $test_file"
  ./lib/bats/bin/bats "$test_file"
done
