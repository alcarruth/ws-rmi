#!/bin/env coffee
#
# server_example.coffee
#

WS_RMI_Server = require('./ws_rmi_server.coffee').WS_RMI_Server
Stack = require('./example_object.coffee').Stack

server = new WS_RMI_Server('localhost', 8085, '.')
stack = new Stack('br549')

server.register(stack)

if module.parent
  exports.server = server
  exports.stack = stack
else
  server.start()
