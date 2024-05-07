#!/usr/bin/env coffee
#
#  file: /src/stack/stack.coffee
#  package: ws-rmi-examples
#

class Stack

  constructor: ->
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
