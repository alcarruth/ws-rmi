#!/bin/env/ coffee
#
#  ws_rmi_server
#

ws = require('ws')
http = require('http')
https = require('https')

RMI_Connection = require('./rmi').Connection


class WS_RMI_Server

  # Connection should extend WS_RMI_Connection in
  # order to add desired WS_RMI_Objects at construction.
  #
  constructor: (@objects, @options = {}, Connection) ->
    @id = "WS_RMI_Server-#{Math.random().toString()[2..]}"
    @log_level = @options?.log_level || 2
    @log = @options?.log || console.log

    @protocol = @options?.protocol || 'ws+unix'
    if @protocol == 'ws+unix'
      @path = @options?.path || '/tmp/ipc_rmi'
      @url = "ws+unix://#{@path}"
    else
      @host = @options?.host || localhost
      @port = @options?.port || 8007
      @path = @options?.path || ''
      @url = "#{@protocol}://#{@host}:#{@port}/#{@path}"

    @connections = []
    @Connection = Connection || RMI_Connection

    if @protocol == 'wss'
      @server = new https.Server(null, @options.credentials)
    else
      @server = new http.Server(null)

    @wss = new ws.Server(server: @server)
    @wss.on('connection', (ws) =>
      try
        @log("trying new connection: #{ws}")
        conn = new RMI_Connection(this, ws, @options)
        @connections.push(conn)
        @log("connection added: #{conn.id}")
      catch error
        msg = "\nWS_RMI_Server_Common: "
        msg += "\nError in connection event handler"
        new Error(msg))

  # Start the server.
  start: =>
    try
      if @protocol == 'ws+unix'
        @server.listen(path: @path)
      else
        @server.listen(host: @host, port: @port)
      @log("server listening at ", @url)

    catch error
      @log error

  # Stop the server.
  stop: =>
    @server.close()
    @log("server stopped.")


module.exports = WS_RMI_Server
