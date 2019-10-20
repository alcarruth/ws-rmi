#!/usr/bin/env coffee
#
#  test/tcp/server.coffee
#

{ Server } = require('../stack-rmi')
options = require('../settings').local_options

server = new Server(options)

module.exports = server
