#!/usr/bin/env coffee
#
# file: /src/test/ipc/index.coffee
# package: ws-rmi
#


client = require('./client')
server = require('./server')

module.exports = {
  client
  server
}
