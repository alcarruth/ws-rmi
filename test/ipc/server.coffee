#!/usr/bin/env coffee
#
#  server.coffee
#

{ Server } = require('./stack-rmi')
options = require('../settings').ipc_options

server = new Server(options)

exports.server = server
