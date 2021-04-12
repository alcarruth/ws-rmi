# -*- coffee -*-
#
#  file: src/examples/stack/stack_rmi_server.coffee
#

fs = require('fs')

{ Stack } = require('./stack')
{ Stack_RMI_Object } = require('./stack_rmi_object')

lib = '../../lib/'
{ WS_RMI_Server } = require(lib + 'ws_rmi_server')
{ WS_RMI_Connection } = require(lib + 'ws_rmi_connection')

class Stack_RMI_Server extends WS_RMI_Server
  constructor: (options = {}) ->
    objects = [new Stack_RMI_Object(options)]
    super(objects, options, WS_RMI_Connection)

exports.Stack_RMI_Server = Stack_RMI_Server
