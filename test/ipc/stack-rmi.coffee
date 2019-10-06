#!/usr/bin/env coffee
#
#  ipc/stack-rmi.coffee
#

{ Stack } = require('../stack')
rmi = require('../../src')


class Stack_RMI_Object extends rmi.Object
  constructor: (options = {}) ->
    stack = new Stack()
    method_names = ['push', 'pop']
    super('stack', stack, method_names, options)

class Stack_RMI_Client extends rmi.IPC_Client
  constructor: (options = {}) ->
    objects = []
    super(rmi.Connection, objects, options)

class Stack_RMI_Server extends rmi.IPC_Server
  constructor: (options = {}) ->
    stack_rmi_obj = new Stack_RMI_Object(options)
    super([stack_rmi_obj], options)


exports.Client = Stack_RMI_Client
exports.Server = Stack_RMI_Server
