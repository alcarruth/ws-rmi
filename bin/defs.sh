#!/bin/bash
#
# package: ws-rmi-examples
# file: /bin/defs.sh
#

bin_dir=$(dirname $0)
. ${bin_dir}/pkg_info

pkg_info ${0}

echo pkg_root: ${pkg_root}
echo pkg_name: ${pkg_name}
echo pkg_branch: ${pkg_branch}

src="${pkg_root}/src"
build="${pkg_root}/${pkg_branch}"
node_modules="${pkg_root}/node_modules/"

function clean {
  echo "cleaning ${build}"
  rm -rf ${build}
  mkdir -p ${build}/doc/
  mkdir -p ${build}/lib/
  mkdir -p ${build}/client/
  mkdir -p ${build}/server/
  mkdir -p ${build}/common/
  mkdir -p ${build}/test/
  mkdir -p ${build}/test/
}

function build_doc {
  echo "building ws-rmi/doc"
  cp -r ./src/doc/ ${build}
}

function build_lib {
  echo "building ${build}/lib"
  mkdir -p ${build}/lib
  coffee -c -o ${build}/lib ./src/lib/*.coffee > /dev/null
  coffee -c -o ${build} ./src/index.coffee > /dev/null
}

function build_client {
  echo "building ${build}/client"
  mkdir -p ${build}/client
  coffee -c -o ${build}/client/ ./src/client/*.coffee > /dev/null
}

function build_server {
  echo "building ${build}/server"
  mkdir -p ${build}/server
  coffee -c -o ${build}/server ./src/server/*.coffee > /dev/null
}

function build_common {
  echo "building ${build}/common"
  mkdir -p ${build}/common
  coffee -c -o ${build}/common ./src/common/*.coffee > /dev/null
}

function build_test {
  echo "building ${build}/test"
  mkdir -p ${build}/test/
  coffee -c -o ${build}/test ./src/test/*.coffee > /dev/null
  for dir in examples ipc remote ipc_proxy; do
    echo "building ${build}/test/${dir}/"
    mkdir -p ${build}/test/${dir}/
    coffee -cM -o ${build}/test/${dir}/ ./src/test/${dir}/*.coffee > /dev/null
  done
}

function browserify {
  node ${pkg_root}/node_modules/browserify/bin/cmd.js $@
}

function build_browser {
  echo "building ${build}/test/browser"
  mkdir -p ${build}/test/browser/js/
  cp ${src}/test/browser/index.html ${build}/test/browser/
  cp -r ${src}/test/browser/css/ ${build}/test/browser/
  #coffee -cM -o ${build}/test/browser/js/ ./src/test/remote_client_nodep.coffee > /dev/null
  #browserify ${build}/test/remote/client.js > ${build}/test/browser/js/remote_client.js
  cp ${build}/lib/rmi_client_nodep.js ${build}/test/browser/js/ws_rmi.js
  cp ${build}/test/remote/client.js ${build}/test/browser/js/test_client.js
}

function build_stacktrace {
  echo "building ${build}/test/browser/js/stacktrace.js"
  browserify ${build}/lib/stacktrace.js > ${build}/test/browser/js/stacktrace.js
  cp ${node_modules}/stacktrace-js/dist/stacktrace.js ${build}/test/browser/js/
}

function build {
  build_doc
  build_lib
  build_client
  build_server
  build_common
  build_test
  build_browser
  build_stacktrace
}
