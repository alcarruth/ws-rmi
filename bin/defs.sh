#!/bin/bash

#root_dir="/var/www/git/projects/ws-rmi"
root_dir="."

function clean {
  rm -rf ./lib/ ./examples/
}

function build {
  build_lib
  build_examples
}

function build_lib {
  echo "building ws-rmi/lib"
  mkdir -p ./lib
  coffee -c -o ./lib ./src/lib/*.coffee > /dev/null
  coffee -c -o . ./src/index.coffee > /dev/null
}

function build_examples {
  echo "building ws-rmi/examples"
  mkdir -p ./examples/stack/ipc ./examples/stack/tcp
  mkdir -p ./examples/browser/js ./examples/browser/css
  coffee -c -o ./examples/stack/ ./src/examples/stack/*.coffee
  coffee -c -o ./examples/stack/ipc/ ./src/examples/stack/ipc/*.coffee
  coffee -c -o ./examples/stack/tcp/ ./src/examples/stack/tcp/*.coffee
  cp ./src/index.html ./examples/browser
  cp ./src/css/* ./examples/css
  cp ./lib/ws_rmi_client.js ./lib/rmi.js ./examples/js
  cp ./examples/stack/settings.js ./examples/js
