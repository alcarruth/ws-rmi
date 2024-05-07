# -*- coffee -*-
#
#  file: /src/stack/stack_rmi_server.coffee
#  package: ws-rmi-examples
#

fs = require('fs')

{
  Stack_RMI_Object
  Stack_RMI_Stub
  #
} = require('./stack_rmi_object')

{
  WS_RMI_Connection
  WS_RMI_Server
  #
#} = require('ws-rmi/src/server')
} = require('ws-rmi/server')


class Stack_RMI_Server extends WS_RMI_Server
  constructor: (options = {}) ->
    objects = [new Stack_RMI_Object(options)]
    super(objects, options, WS_RMI_Connection)

exports.Stack_RMI_Server = Stack_RMI_Server
