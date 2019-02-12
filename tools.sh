#!/bin/bash

EXAMPLE_DIR="./build/js6/example";
EXAMPLE_SRC="src/example/";
BABEL="./node_modules/.bin/babel";
COFFEE_DIR="./build/coffee/";
JS6_DIR="./build/js6/";
JS5_DIR="./build/js5/";

function build {
  clean;
  build_example;
  build_libs;
}

function clean {
  rmdirs && mkdirs;
}

function rmdirs {
  rm -rf ${JS5_DIR} ${JS6_DIR} ${COFFEE_DIR};
}

function mkdirs {
  mkdir -p ${JS5_DIR}/lib/ ${JS5_DIR}/example/;
  mkdir -p ${JS6_DIR}/lib/ ${JS6_DIR}/example/;
  mkdir -p ${COFFEE_DIR}/lib/ ${COFFEE_DIR}/example/;
}

function build_example {
  cp ${EXAMPLE_SRC}/client.html ${EXAMPLE_DIR};
  cp ${EXAMPLE_SRC}/*.coffee ${COFFEE_DIR}/example/;
  cat ${EXAMPLE_SRC}/options.coffee > ${COFFEE_DIR}/example/web_client.coffee;
  cat ${EXAMPLE_SRC}/stack.coffee >> ${COFFEE_DIR}/example/web_client.coffee;
  cat ${EXAMPLE_SRC}/client.coffee >> ${COFFEE_DIR}/example/web_client.coffee;
  coffee -cMo ${JS6_DIR}/example/ ${COFFEE_DIR}/example/*.coffee;
}

function build_libs {
  cp ./src/coffee/*.coffee ${COFFEE_DIR}/lib/;
  coffee -cMo ${JS6_DIR}/lib/ ${COFFEE_DIR}/lib/*.coffee;
  npx babel ${JS6_DIR}/lib/ -d ${JS5_DIR}/lib/;
}

function lint {
  npx eslint ${JS5_DIR}/lib/;
}

function test_all {
  npx mocha --require babel-core/register;
}

export clean;
export build;
