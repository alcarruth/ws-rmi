#!/bin/env/ coffee
#
# ws_rmi_server_common
#

# TODO:
#
#  - Try this with promises
#

WebSocket = require('ws')
http = require('http')
https = require('https')

log = (msg) ->
  console.log(msg)

# WS_RMI_Server_Common contains code common to both
# WS_RMI_Server and WSS_RMI_Server defined below
#
class WS_RMI_Server_Common

  constructor: (@server, options) ->

    { @host, @port, @path, @protocol } = options

    @url = "#{@protocol}://#{@host}:#{@port}"

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
      log("server listening at url: #{@url}")
    catch error
     console.log error

  # TODO:
  # add stop() method
  stop: =>
    @server.close()
    log("server stopped.")

  # register an object for remote method invocation by the
  # handle_request method (below)
  #
  register: (app) =>
    @registry[app.id] = app
    log("registering #{app.id}")

  deregister: (id) =>
    delete @registry[id]
    log("deregistered #{id}")


  # parse the request, use the obj_id to look up the
  # corresponding object and invoke the method on the
  # supplied arguments
  #
  handle_request: (msg, client) =>
    msg_obj = JSON.parse(msg)
    { obj_id, method, args, cb_id } = msg_obj

    console.log("\nWS_RMI_Server:")
    console.log msg_obj

    # args is a list - a splat from the original
    # client side invocation, so we need to "de-splat"
    # here.

    cb = (res) =>
      client.send(JSON.stringify( [cb_id, res]))

    try
      @registry[obj_id][method](args, cb)
    catch error
      console.log("Error in ws_rmi_server:")
      console.log(error)
      ###
      console.log("  obj_id: #{msg_obj.obj_id}")
      console.log("  name: #{msg_obj.name}")
      console.log("  args: #{msg_obj.args}")
      console.log("  cb_id: #{msg_obj.cb_id}")
      ###

    # TODO:
    # app cb to an appropriate error for client

# WS_RMI_Server is the insecure version and can be run without root
# access since it does not require access to the SSL credentials
#
class WS_RMI_Server extends WS_RMI_Server_Common
  constructor: (options) ->
    webserver = http.createServer(null)
    super(webserver, options)
    @protocol = 'ws'



# WSS_RMI_Server is the secure version and requires
# access to SSL credentials for the site.
#
class WSS_RMI_Server extends WS_RMI_Server_Common
  constructor: (options, credentials) ->
    webserver = https.createServer(null, credentials)
    super(webserver, options)
    @protocol = 'wss'



exports.Server = WS_RMI_Server
exports.SServer = WSS_RMI_Server
