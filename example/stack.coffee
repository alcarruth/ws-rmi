
WS_RMI_Stub = WS_RMI_Stub || require('./ws_rmi_client').WS_RMI_Stub

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

  @add_stub('push')
  @add_stub('pop')

if window?
  window.Stack = Stack
  window.Stack_Stub = Stack_Stub
else
  exports.Stack = Stack
  exports.Stack_Stub = Stack_Stub
