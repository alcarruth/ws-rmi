#!/usr/bin/env coffee
# 
#  file: src/examples/stack/ipc/index.coffee
#  package: ws-rmi-examples
# 

client = require('./client')
server = require('./server')

exports.client = client
exports.server = server
