#!/bin/bash

#root_dir="/var/www/git/projects/ws-rmi"
root_dir="."

function clean {
  rm -rf ./lib/ ./examples/
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
  ln -s ../../lib ./examples/stack/
  coffee -c -o ./examples/stack/ ./src/examples/stack/*.coffee
  coffee -c -o ./examples/stack/ipc/ ./src/examples/stack/ipc/*.coffee
  coffee -c -o ./examples/stack/tcp/ ./src/examples/stack/tcp/*.coffee
  coffee -c -o ./examples/stack/nginx/ ./src/examples/stack/nginx/*.coffee
}

function browserify {
  node node_modules/browserify/bin/cmd.js $@
}

function build_browser {
  echo "building ws-rmi/examples/browser"
  cp ./src/html/examples.html ./examples/browser/index.html
  cp ./src/css/* ./examples/browser/css
  browserify ./examples/stack/nginx/client.js > ./examples/browser/js/ws-rmi-client.js
}

function build {
  build_lib
  build_examples
  build_browser
}
