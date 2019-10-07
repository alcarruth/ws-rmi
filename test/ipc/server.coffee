#!/usr/bin/env coffee
#
#  test/ipc/server.coffee
#

{ Server } = require('../stack-rmi')
options = require('../settings').ipc_options

server = new Server(options)

module.exports = server
