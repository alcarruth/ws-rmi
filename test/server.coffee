#!/usr/bin/env coffee
#
#  server.coffee
#

{ Server } = require('./ws-stack-rmi')
options = require('./settings').local_options

console.log options
server = new Server(options)

exports.server = server

