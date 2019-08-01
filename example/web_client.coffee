#!/bin/env/ coffee
#
# ws_rmi_client
#

WebSocket = window?.WebSocket || require('ws')

log = (msg) ->
  console.log(msg)

class WS_RMI_Client

  constructor: (@options) ->
    { @host, @port, @path, @protocol } = @options

    @url = "#{@protocol}://#{@host}:#{@port}/#{@path}"

    @registry = {}
    @cnt = 0
    @cb_hash = {}
    @stubs = []

  connect: (url) =>
    @url = url if url
    @server = new WebSocket(@url)
    @server.onopen = @onOpen
    @server.onmessage = @onMessage
    @server.onclose = @onClose
    @server.onerror = @onError
    true

  onOpen: (evt) =>
    log("connected to rmi server at #{@url}")

  onMessage: (evt) =>
    @handle_response(evt.data)

  onClose: (evt) =>
    log("socket closed by server at #{@url}")

  onError: (evt) =>

  disconnect: =>
    log("disconnecting from server at #{@url}")
    @server.close()

  register: (stub) =>
    @stubs.push(stub)
    stub.register(this)

  send_request: (obj_id, name, args, cb) =>
    cb_id = @cnt++
    @cb_hash[cb_id] = cb? && cb || console.log
    rmi_args = { obj_id: obj_id, name: name, args: args, cb_id: cb_id }
    @server.send( JSON.stringify(rmi_args))

  handle_response: (msg) =>
    [cb_id, res] = JSON.parse(msg)
    @cb_hash[cb_id](res)
    delete @cb_hash[cb_id]


# RMI_Stub is a generic rmi client super class Using it involves
# extending it and calling the static (class) method 'remote_methods'
# with a list of the methods available on the remote object.  The
# resulting methods are just stubs which call the 'invoke' method
# (below) to contact the remote object server.
#
class WS_RMI_Stub

  @add_stub = (name) ->
    @::[name] = (args..., cb) ->
      @invoke(name, args, cb)

  constructor: (@id) ->

  log_cb: (err, res) ->
    console.log(res)

  register: (ws_rmi_client) =>
    @ws_rmi_client = ws_rmi_client

  invoke: (name, args, cb) =>
    cb = cb || ->
    @ws_rmi_client.send_request(@id, name, args, cb)

if window?
  window.ws_rmi =
    WS_RMI_Client: WS_RMI_Client
    WS_RMI_Stub: WS_RMI_Stub
else
  exports.WS_RMI_Client = WS_RMI_Client
  exports.WS_RMI_Stub = WS_RMI_Stub
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

# example/settings.coffee

settings =

  app_id: 'br549'

  local:
    host: "localhost"
    port: 8085
    path: ""
    protocol: 'ws'

  external:
    host: "alcarruth.net"
    port: 443
    path: "/wss/rmi_example"
    protocol: 'wss'

if window?
  window.settings = settings

else
  exports.app_id = settings.app_id
  exports.local = settings.local
  exports.external = settings.external
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
