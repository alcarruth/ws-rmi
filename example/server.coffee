#!/usr/bin/env coffee
#
# server_example
#

WS_RMI_Server = require('./ws_rmi_server').WS_RMI_Server
Stack = require('./stack').Stack
options = require('./options').private

server = new WS_RMI_Server(options.host, options.port, options.path)
stack = new Stack('br549')

server.register(stack)

if module.parent
  exports.server = server
  exports.stack = stack
else
  server.start()
