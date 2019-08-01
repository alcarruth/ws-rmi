#
# example/stack.coffee
#

WS_RMI_Stub = WS_RMI_Stub || require('../lib').WS_RMI_Stub

class Stack

  # note that the object must have an id in order to
  # register and operate with the rmi server
  #
  constructor: (@id) ->
    @stack = []

  push: (x, cb) =>
    @stack.push(x)
    console.log @stack
    cb(true)

  pop: (cb) =>
    cb( @stack.pop())
    console.log @stack


class Stack_Stub extends WS_RMI_Stub
  #@remote_methods('push','pop')
  @add_stub('push')
  @add_stub('pop')


if exports?
  exports.Stack = Stack
  exports.Stack_Stub = Stack_Stub
