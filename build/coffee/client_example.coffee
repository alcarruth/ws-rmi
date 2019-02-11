

WS_RMI_Client = WS_RMI_Client || require('./ws_rmi_client.coffee').WS_RMI_Client
Stack_Stub = Stack_Stub || require('./example_object.coffee').Stack_Stub


class StackApp

  constructor: (@url = 'ws://localhost:8085') ->
    @client = new WS_RMI_Client(@url)
    @stack = new Stack_Stub('br549')
    @client.register(@stack)

  connect: =>
    @client.connect()

  disconnect: =>
    @client.disconnect()

  def_cb: (x) =>
    console.log([x])

  push: (x, cb = @def_cb) =>
    @stack.push(x, cb)

  pop: (cb = @def_cb) =>
    @stack.pop(cb)



if window?
  window.app = new StackApp('wss://armazilla.net/wss/rmi_example')
else
  exports.app = new StackApp('wss://armazilla.net/wss/rmi_example')
