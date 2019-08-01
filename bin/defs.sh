#!/bin/bash

function clean {

  rm -rf ./example/*
  rm -rf ./lib/*

  mkdir -p ./example
  mkdir -p ./lib
}

function build {

  coffee -c -o ./lib/ ./src/lib/ws_rmi_client.coffee
  coffee -c -o ./lib/ ./src/lib/ws_rmi_server.coffee
  coffee -c -o ./lib/ ./src/lib/index.coffee

  coffee -c -o ./example/ ./src/example/client.coffee
  coffee -c -o ./example/ ./src/example/server.coffee
  coffee -c -o ./example/ ./src/example/stack.coffee
  coffee -c -o ./example/ ./src/example/index.coffee
  coffee -c -o ./example/ ./src/example/settings.coffee

  cp ./src/example/index.html ./example/
  cp ./src/example/build.sh ./example/
  cp ./lib/ws_rmi_client.js ./example/
}
