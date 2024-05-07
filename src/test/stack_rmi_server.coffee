# -*- coffee -*-
#
#  file: /src/stack/stack_rmi_server.coffee
#  package: ws-rmi-examples
#

{ RMI_Server, RMI_Connection } = require('../lib')
{ Stack } = require('./stack')

class Stack_RMI_Server extends RMI_Server
  constructor: (options = {}) ->
    super({ options })
    obj = new Stack()
    method_names = ['push', 'pull']
    @add_object({ obj, method_names })
    @update_registry()


exports.Stack_RMI_Server = Stack_RMI_Server
