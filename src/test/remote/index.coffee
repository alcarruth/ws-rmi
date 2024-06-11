#!/usr/bin/env coffee
#
# file: /src/test/remote/index.coffee
# package: ws-rmi
#


client = require('./client')
server = require('./server')

module.exports = {
  client
  server
}
