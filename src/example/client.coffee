
WS_RMI_Client = WS_RMI_Client || require('./ws_rmi_client').WS_RMI_Client
Stack_Stub = Stack_Stub || require('./stack').Stack_Stub
options = options || require('./options')


class StackApp

  constructor: (@url = options.private.url()) ->
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
  window.app = new StackApp(options.public.url())
else
  exports.app = new StackApp(options.private.url())
