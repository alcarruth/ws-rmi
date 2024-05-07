#  -*- coffee -*-
#
#  file: src/stack/stack_rmi_object.coffee
#  package: ws-rmi-examples
#

{ Stack } = require('./stack')

{
  RMI_Object
  RMI_Stub
  #
} = require('ws-rmi/common')


class Stack_RMI_Object extends RMI_Object
  constructor: (options = {}) ->
    obj = new Stack()
    method_names = ['push', 'pop']
    super({ obj, method_names, options })


class Stack_RMI_Stub extends RMI_Stub
  constructor: (options = {}) ->

    super({ obj_id, method_names


exports.Stack_RMI_Object = Stack_RMI_Object
exports.Stack_RMI_Stub = Stack_RMI_Stub
