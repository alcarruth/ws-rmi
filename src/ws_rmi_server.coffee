#!/bin/env/ coffee
# 
# ws_rmi_server.coffee
# 

WebSocket = require('ws')
https = require('https')
http = require('http')

log = (msg) ->
  console.log(msg)

# WS_RMI_Server_Common contains code common to both
# WS_RMI_Server and WSS_RMI_Server defined below
# 
class WS_RMI_Server_Common
   
  constructor: (@host, @port, @path) ->
    @registry = {}
    @clients = []
    if @server
      @wss = new WebSocket.Server(server: @server)
    else
      @wss = new WebSocket.Server(host: @host, port: @port, path: @path)
    @wss.on('connection', (client) =>
      client.on('message', (msg) =>
        console.log msg
        @handle_request(msg, client))
      @clients.push(client)
      log("client added: #{client._socket.server._connectionKey}"))

  # start the server
  # 
  start: =>
    console.log "Hi Al!"
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
    [obj_id, name, args, cb_id] = JSON.parse(msg)
    console.log [obj_id, name, args, cb_id]

    @registry[obj_id][name](args, (res) =>
      log([cb_id, res])
      client.send(JSON.stringify( [cb_id, res])))




# WSS_RMI_Server is the secure version and requires
# access to SSL credentials for the site.
# 
class WSS_RMI_Server extends WS_RMI_Server_Common
  constructor: (host, port, path, @credentials) ->
    super(host, port, path)
    @server = https.createServer(@credentials, null)
    @protocol = 'wss'




# WS_RMI_Server is the insecure version and can be
# run without root access since it does not require
# access to the SSL credentials
# 
class WS_RMI_Server extends WS_RMI_Server_Common
  constructor: (host, port, path) ->
    super(host, port, path)
    #@server = http.createServer(null)
    @protocol = 'ws'


exports.WS_RMI_Server = WS_RMI_Server
exports.WSS_RMI_Server = WSS_RMI_Server


