#
# example_object.coffee


WS_RMI_Stub = require('./ws_rmi_client.coffee').WS_RMI_Stub

class Stack

  # note that the object must have an id in order to
  # register and operate with the rmi server
  # 
  constructor: (@id) ->
    @stack = []

  push: (args,cb) =>
    cb(@stack.push(args.x))

  pop: (args,cb) =>
    cb( @stack.pop())


class Stack_Stub extends WS_RMI_Stub

  constructor: (id) ->
    super(id)
    WS_RMI_Stub.remote_methods(['push', 'pop'])


exports.Stack = Stack
exports.Stack_Stub = Stack_Stub
