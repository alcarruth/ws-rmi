#!/bin/env/ coffee
#
# ws_rmi_server_common.coffee
#

WebSocket = require('ws')

log = (msg) ->
  console.log(msg)

# WS_RMI_Server_Common contains code common to both
# WS_RMI_Server and WSS_RMI_Server defined below
#
class WS_RMI_Server_Common

  constructor: (@server, @host, @port, @path) ->
    @registry = {}
    @clients = []
    @wss = new WebSocket.Server(server: @server)
    @wss.on('connection', (client) =>
      client.on('message', (msg) =>
        @handle_request(msg, client))
      client.on('close', =>
        log("client disconnected: #{client._socket.server._connectionKey}"))
      @clients.push(client)
      log("client added: #{client._socket.server._connectionKey}"))

  # start the server
  #
  start: =>
    try
      @server.listen(@port, @host)
      log("server listening at url: #{@protocol}://#{@host}:#{@port}")
    catch error
     console.log error

  # register an object for remote method invocation by the
  # handle_request method (below)
  #
  register: (obj) =>
    @registry[obj.id] = obj
    log("registering #{obj.id}")
    log(@registry)

  # parse the request, use the obj_id to look up the
  # corresponding object and invoke the method on the
  # supplied arguments
  #
  handle_request: (msg, client) =>
    msg_obj = JSON.parse(msg)
    #console.log msg_obj
    { obj_id, name, args, cb_id } = msg_obj

    # args is a list - a splat from the original
    # client side invocation, so we need to "de-splat"
    # here.

    args.push( (res) =>
      client.send(JSON.stringify( [cb_id, res])))

    @registry[obj_id][name].apply(null, args)


exports.WS_RMI_Server_Common = WS_RMI_Server_Common
