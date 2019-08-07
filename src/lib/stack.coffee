#!/usr/bin/env coffee
#
# stack.coffee
#

class Stack_CB

  constructor: ->
    @stack = []

  push: (x, cb) =>
    console.log("\nStack_CB")
    console.log(x:x, cb:cb)
    @stack.push(x)
    console.log @stack
    cb(true)

  pop: (cb) =>
    cb( @stack.pop())
    console.log @stack

exports.Stack = Stack_CB
