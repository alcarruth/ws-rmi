#!/usr/bin/env coffee
#
#  file: /src/test/ipc/server.coffee
#  package: ws-rmi
#

options = require('./options')
{ Stack_RMI_Server } = require('../stack_rmi_server')

server = new Stack_RMI_Server(options)

module.exports = server
