# -*- coffee -*-
#
#  file: /src/stack/stack_rmi_client.coffee
#  package: ws-rmi-examples
#

{
  Stack_RMI_Object
  Stack_RMI_Stub
  #
} = require('./stack_rmi_object')

{
  WS_RMI_Client
  WS_RMI_Connection
  #
#} = require('ws-rmi/src/client')
} = require('ws-rmi/client')


class Stack_RMI_Client extends WS_RMI_Client
  constructor: (options = {}) ->
    #objects = [new Stack_RMI_Object(options)]
    objects = []
    super(objects, options, WS_RMI_Connection)


exports.Stack_RMI_Client = Stack_RMI_Client
