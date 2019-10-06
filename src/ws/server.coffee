#!/bin/env/ coffee
#
#  ws_rmi_server
#

ws = require('ws')
http = require('http')
https = require('https')

{ RMI_Connection } = require('../rmi')

# WS_RMI_Server_Common contains code common to both
# WS_RMI_Server and WSS_RMI_Server defined below
#
class WS_RMI_Server_Common

  # Connection should extend WS_RMI_Connection in
  # order to add desired WS_RMI_Objects at construction.
  #
  constructor: (@server, @objects, @options) ->
    @id = "WS_RMI_Server-#{Math.random().toString()[2..]}"
    @log_level = @options?.log_level || 2
    @log = @options?.log || console.log
    @host = @options?.host || 'localhost'
    @port = @options?.port || 8086
    @protocol = @options?.protocol || 'ws'
    @url = "#{@protocol}://#{@host}:#{@port}"
    @connections = []

    @wss = new ws.Server(server: @server)
    @wss.on('connection', (ws) =>
      try
        @log("trying new connection: #{ws}")
        conn = new RMI_Connection(this, ws, @log_level)
        @connections.push(conn)
        @log("connection added: #{conn.id}")
      catch error
        msg = "\nWS_RMI_Server_Common: "
        msg += "\nError in connection event handler"
        new Error(msg))

  # Start the server.
  start: =>
    try
      @server.listen(@port, @host)
      @log("server listening at url: #{@url}")

    catch error
      @log error

  # Stop the server.
  stop: =>
    @server.close()
    @log("server stopped.")


# WS_RMI_Server is the insecure version and can be run without root
# access since it does not require access to the SSL credentials
#
class WS_RMI_Server extends WS_RMI_Server_Common

  constructor: (objects, options) ->
    webserver = http.createServer(null)
    super(webserver, objects, options)
    @protocol = 'ws'


# WSS_RMI_Server is the secure version and requires
# access to SSL credentials for the site.
#
class WSS_RMI_Server extends WS_RMI_Server_Common

  constructor: (credentials, objects, options) ->
    webserver = https.createServer(null, credentials)
    super(webserver, objects, options)
    @protocol = 'wss'


exports.WS_RMI_Server = WS_RMI_Server
exports.WSS_RMI_Server = WSS_RMI_Server
