#!/bin/bash

#root_dir="/var/www/git/projects/ws-rmi"
root_dir="."

function clean {
  rm -rf ./lib/* ./examples/*
  mkdir -p ./lib ./examples/stack/ipc ./examples/stack/tcp
}

function build {
  coffee -c -o ./lib ./src/lib/*.coffee > /dev/null
  coffee -c -o ./examples/stack/ ./src/examples/stack/*.coffee
  coffee -c -o ./examples/stack/ipc/ ./src/examples/stack/ipc/*.coffee
  coffee -c -o ./examples/stack/tcp/ ./src/examples/stack/tcp/*.coffee
}
