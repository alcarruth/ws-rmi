#  -*- coffee -*-
#
#  file: src/examples/stack/stack_rmi_object.coffee
#

{ Stack } = require('./stack')
{ WS_RMI_Object, WS_RMI_Stub } = require('./lib/ws_rmi_object')

class Stack_RMI_Object extends WS_RMI_Object
  constructor: (options = {}) ->
    stack = new Stack()
    method_names = ['push', 'pop']
    super('stack', stack, method_names, options)

class Stack_RMI_Stub extends WS_RMI_Stub
  constructor: (options = {}) ->
    objects = []
    super(objects, options)

exports.Stack_RMI_Object = Stack_RMI_Object
exports.Stack_RMI_Stub = Stack_RMI_Stub
