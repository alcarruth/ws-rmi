#!/usr/bin/env coffee
# 
#  file: /src/stack/index.coffee
#  package: ws-rmi-examples
# 

ipc = require('./ipc')
tcp = require('./tcp')

exports.ipc = ipc
exports.tcp = tcp
