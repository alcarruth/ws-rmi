#!/usr/bin/env coffee
# -*- coding: utf-8 -*-
#
# ws_rmi_example.coffee
#

ws_rmi = require('../lib/')

name = 'stack'
app_id = 'example_app'


# A Stack is the fundamental Object for which we wish to provide
# RMI capability.  This version of Stack uses Promises to provide
# asynchronous access.
#
class Stack

  constructor: ->
    @stack = []

  push: (x) =>
    new Promise((resolve, reject) =>
      try
        resolve @stack.push(x)
      catch err
        reject("Error pushing #{x} to stack"))

  pop: =>
    new Promise((resolve, reject) =>
      try
        resolve @stack.pop()
      catch err
        reject("Error popping from stack"))




# A Stack_Connection is a WS_RMI_Connection instance with
# a WS_RMI_Object created from a Stack.  The WS_RMI_Object
# constructor will register the object with the connection.
#
class Stack_Connection extends ws_rmi.Connection
  constructor: (owner, ws) ->
    super(owner, ws, 2)



# An extension which specifies the Connection arg to WS_RMI_Client
#
class Stack_Client extends ws_rmi.Client
  constructor: (options) ->
    console.log 'Stack_Client'
    super(options, [])


# An extension which specifies the Connection arg to WS_RMI_Server
#
class Stack_Server extends ws_rmi.Server
  constructor: (options) ->
    console.log 'Stack_Server'
    stack_obj = new ws_rmi.Object(
      'rmi_example', new Stack(), ['pop', 'push'])
    super(options, [stack_obj])


if not window?
  exports.Stack_Server = Stack_Server
  exports.Stack_Client = Stack_Client
