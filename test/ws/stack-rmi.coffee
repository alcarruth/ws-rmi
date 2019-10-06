#!/usr/bin/env coffee
#
#  ws/stack-rmi.coffee
#

{ Stack } = require('../stack')
rmi = require('../../src')


class Stack_RMI_Object extends rmi.Object
  constructor: (options = {}) ->
    stack = new Stack()
    method_names = ['push', 'pop']
    super('stack', stack, method_names, options)

class Stack_RMI_Client extends rmi.WS_Client
  constructor: (options = {}) ->
    objects = []
    super(rmi.Connection, objects, options)

class Stack_RMI_Server extends rmi.WS_Server
  constructor: (options = {}) ->
    stack_rmi_obj = new Stack_RMI_Object(options)
    super([stack_rmi_obj], options)


exports.Client = Stack_RMI_Client
exports.Server = Stack_RMI_Server
