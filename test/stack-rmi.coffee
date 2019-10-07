#!/usr/bin/env coffee
#
#  test/stack-rmi.coffee
#

{ Stack } = require('./stack')
ws_rmi = require('../src')


class Stack_RMI_Object extends ws_rmi.Object
  constructor: (options = {}) ->
    stack = new Stack()
    method_names = ['push', 'pop']
    super('stack', stack, method_names, options)

class Stack_RMI_Client extends ws_rmi.Client
  constructor: (options = {}) ->
    objects = []
    super(objects, options, ws_rmi.Connection)

class Stack_RMI_Server extends ws_rmi.Server
  constructor: (options = {}) ->
    objects = [new Stack_RMI_Object(options)]
    super(objects, options, ws_rmi.Connection)


exports.Client = Stack_RMI_Client
exports.Server = Stack_RMI_Server
