#!/bin/bash

#root_dir="/var/www/git/projects/ws-rmi"
root_dir="."

function clean {
    rm -rf ./lib/ ./client/ ./server/ ./common/
}

function build_lib {
    echo "building ws-rmi/lib"
    mkdir -p ./lib
    coffee -c -o ./lib ./src/lib/*.coffee > /dev/null
    coffee -c -o . ./src/index.coffee > /dev/null
}

function build_client {
    echo "building ws-rmi/client"
    mkdir -p ./client
    coffee -c -o ./client/ ./src/client/*.coffee > /dev/null
}

function build_server {
    echo "building ws-rmi/server"
    mkdir -p ./server
    coffee -c -o ./server ./src/server/*.coffee > /dev/null
}

function build_common {
    echo "building ws-rmi/common"
    mkdir -p ./common
    coffee -c -o ./common ./src/common/*.coffee > /dev/null
}

function build {
    build_lib
    build_common
    build_client
    build_server
}
