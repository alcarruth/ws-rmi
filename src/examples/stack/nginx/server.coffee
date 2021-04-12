#!/usr/bin/env coffee
#
#  file: src/examples/stack/web/server.coffee
#

{ Stack_RMI_Server } = require('../stack_rmi_server')
options = require('./settings').ipc_options

server = new Stack_RMI_Server(options)

module.exports = server
