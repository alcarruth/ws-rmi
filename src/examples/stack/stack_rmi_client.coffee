# -*- coffee -*-
#
#  file: src/examples/stack/stack_rmi_client.coffee
#

# { Stack_RMI_Stub } = require('./stack_rmi_object')

{ WS_RMI_Connection } = require('./lib/ws_rmi_connection')
{ WS_RMI_Client } = require('./lib/ws_rmi_client')

class Stack_RMI_Client extends WS_RMI_Client
  constructor: (options = {}) ->
    objects = []
    super(objects, options, WS_RMI_Connection)

exports.Stack_RMI_Client = Stack_RMI_Client
