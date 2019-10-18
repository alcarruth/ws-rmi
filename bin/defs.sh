#!/bin/bash

#root_dir="/var/www/git/projects/ws-rmi"
root_dir="."

function clean {
  rm -rf ./lib/*
  mkdir -p ./lib
}

function build {
  coffee -c -o ./lib ./src/*.coffee
}
