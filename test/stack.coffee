#!/usr/bin/env coffee
#
#  stack.coffee
#

class Stack

  constructor: ->
    @stack = []

  push: (x) =>
    new Promise (resolve, reject) =>
      try
        resolve(@stack.push(x))
      catch error
        reject(error)

  pop: =>
    new Promise (resolve, reject) =>
      try
        resolve(@stack.pop())
      catch error
        reject(error)


exports.Stack = Stack
