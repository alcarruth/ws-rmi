#!/usr/bin/env coffee
#
#  file: src/examples/stack/ipc/server.coffee
#

{ Stack_RMI_Server } = require('../stack_rmi_server')
{ ipc_options }= require('./settings')

server = new Stack_RMI_Server(ipc_options)

module.exports = server
