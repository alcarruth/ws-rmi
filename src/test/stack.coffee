#!/usr/bin/env coffee
#
#  file: /src/test/stack.coffee
#  package: ws-rmi
#

{ random_id, Logger } = require('armazilla-util')

class Stack

  constructor: ->
    @id = random_id(this)
    @stack = []

  push: (x) =>
    new Promise (resolve, reject) =>
      try
        resolve(@stack.push(x))
        console.log @stack
      catch error
        reject(error)

  pop: =>
    new Promise (resolve, reject) =>
      try
        resolve(@stack.pop())
        console.log @stack
      catch error
        reject(error)


exports.Stack = Stack
