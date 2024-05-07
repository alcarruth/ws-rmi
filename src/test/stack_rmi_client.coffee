# -*- coffee -*-
#
#  file: /src/test/stack_rmi_client.coffee
#  package: ws-rmi
#

{ RMI_Client, RMI_Connection } = require('../lib')
{ Stack } = require('./stack')

class Stack_RMI_Client extends RMI_Client
  constructor: (options = {}) ->
    super({ options })
    obj = new Stack()
    method_names =['push', 'pull']
    @add_object({ obj, method_names })
    @update_registry()


exports.Stack_RMI_Client = Stack_RMI_Client
