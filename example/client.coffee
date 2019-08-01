#
# example/client.coffee
#

#WS_RMI_Client = WS_RMI_Client || require('ws_rmi').WS_RMI_Client
WS_RMI_Client = WS_RMI_Client || require('../lib').WS_RMI_Client
Stack_Stub = Stack_Stub || require('./stack').Stack_Stub
settings = settings || require('./settings')

class Example_Client

  constructor: (@app_id, @options) ->
    @options
    @def_cb = (x) -> console.log(x)
    @stack = new Stack_Stub(@app_id, @def_cb)
    @client = new WS_RMI_Client(@options)
    @client.register(@stack)

  connect: =>
    @client.connect()

  disconnect: =>
    @client.disconnect()

  push: (x,cb) =>
    @stack.push(x, cb || ->)

  pop: (cb) ->
    @stack.pop(cb || console.log)


if window?
  # running in browser
  app_id = settings.app_id
  options = settings.external
  window.app = new Example_Client(app_id, options)

else
  app_id = settings.app_id
  options = settings.local
  app = new Example_Client(app_id, options)

  if module?.parent
    # imported into parent module
    exports.app = app

  else
    # invoked from command line start REPL
    repl = require('repl')
    repl.start('stack> ').context.app = app
