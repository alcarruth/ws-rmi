#!/bin/bash

function clean {

  rm -rf ./example/*
  rm -rf ./lib/*

  mkdir -p ./example
  mkdir -p ./lib
}

function build {

  cp ./src/lib/ws_rmi_client.coffee ./lib/
  cp ./src/lib/ws_rmi_server.coffee ./lib/
  cp ./src/lib/index.coffee ./lib/

  cp ./src/example/client.coffee ./example/
  cp ./src/example/server.coffee ./example/
  cp ./src/example/stack.coffee ./example/
  cp ./src/example/index.coffee ./example/
  cp ./src/example/settings.coffee ./example/
  cp ./src/example/index.html ./example/
  cp ./src/example/build.sh ./example/
}
