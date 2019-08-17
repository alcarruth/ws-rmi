#!/bin/bash

root_dir="/var/www/git/projects/ws-rmi"

function clean {

  pushd ${root_dir}

  rm -rf ./example/*
  rm -rf ./lib/*

  mkdir -p ./example
  mkdir -p ./lib

  popd
}

function build {

  pushd ${root_dir}/src/lib

  coffee -c -o ${root_dir}/lib *.coffee

  popd
}
