#!/bin/env/ coffee
#
#  ws_rmi_server
#

WebSocket = require('ws')
http = require('http')
https = require('https')

# WS_RMI_Server_Common contains code common to both
# WS_RMI_Server and WSS_RMI_Server defined below
#
class WS_RMI_Server_Common

  # Connection should extend WS_RMI_Connection in
  # order to add desired WS_RMI_Objects at construction.
  #
  constructor: (@server, options, Connection) ->
    @id = "WS_RMI_Server-#{Math.random().toString()[2..]}"
    @connections = []

    { @host, @port, @path, @protocol } = options
    @url = "#{@protocol}://#{@host}:#{@port}"

    @wss = new WebSocket.Server(server: @server)
    @wss.on('connection', (ws) =>
      try
        console.log("trying new connection: #{ws}")
        conn = new Connection(this, ws)
        @connections.push(conn)
        console.log("connection added: #{conn.id}")
      catch error
        msg = "\nWS_RMI_Server_Common: "
        msg += "\nError in connection event handler"
        new Error(msg))

  # Start the server.
  start: =>
    try
      @server.listen(@port, @host)
      console.log("server listening at url: #{@url}")
    catch error
     console.log error

  # Stop the server.
  stop: =>
    @server.close()
    console.log("server stopped.")


# WS_RMI_Server is the insecure version and can be run without root
# access since it does not require access to the SSL credentials
#
class WS_RMI_Server extends WS_RMI_Server_Common
  constructor: (options, Connection) ->
    webserver = http.createServer(null)
    super(webserver, options, Connection)
    @protocol = 'ws'


# WSS_RMI_Server is the secure version and requires
# access to SSL credentials for the site.
#
class WSS_RMI_Server extends WS_RMI_Server_Common
  constructor: (credentials, options, Connection) ->
    webserver = https.createServer(null, credentials)
    super(webserver, options)
    @protocol = 'wss'



exports.WS_RMI_Server = WS_RMI_Server
exports.WSS_RMI_Server = WSS_RMI_Server
