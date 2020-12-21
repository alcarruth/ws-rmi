#!/bin/env/ coffee
#
#  ws_rmi_server
#

process = require('process')
fs = require('fs')
ws = require('ws')
http = require('http')
https = require('https')

RMI_Connection = require('./rmi').Connection

# An instance of WS_RMI_Server provides remote method invocation (RMI)
# services for its @objects to clients connected by a websocket.
#
class WS_RMI_Server

  # @objects: an array of remotable objects
  #
  # @options: options for the http(s) server and for logging etc.
  #
  # Connection: a connection class extending WS_RMI_Connection.
  # It defaults to WS_RMI_Connection.  A subclass can be used to provide
  # extra functionality particular to the type of rmi objects being served.
  # At this point the only known reason for providing this option is for
  # the db_rmi stuff which required additional setup after @init_stubs().
  # It seems like this might frequently be the case though...
  #
  constructor: (@objects, @options = {}, Connection) ->
    @id = "WS_RMI_Server-#{Math.random().toString()[2..]}"
    @log_level = @options?.log_level || 2
    @log = @options?.log || console.log

    # The connection class - defaults to RMI_Connection
    @Connection = Connection || RMI_Connection

    # connections added here as they are created
    @connections = []

    # default to 'ws+unix'
    @protocol = @options?.protocol || 'ws+unix'

    # Protocol 'ws+unix' means IPC (inter process communication),
    # basically unix domain sockets (or something similar in
    # Windows). See docs for npm package ws.
    #
    if @protocol == 'ws+unix'
      @path = @options?.path || '/tmp/ipc_rmi'
      @url = "ws+unix://#{@path}"

      # Catch 'exit' (Ctrl-D)
      process.on('exit', =>
        @log("WS_RMI_Server: received 'exit' (Ctrl-D)")
        #@stop()
        )

      # Catch 'SIGQUIT'
      process.on('SIGQUIT', =>
        @log("WS_RMI_Server: received 'SIGQUIT'"))

      # Catch 'SIGINT' (Ctrl-C)
      process.on('SIGINT', =>
        @log("WS_RMI_Server: received 'SIGINT' (Ctrl-C)")
        @stop()
        process.exit()
        )
      #  if fs.existsSync(@path)
      #    fs.unlinkSync(@path)
      #    process.exit())

    # Otherwise we need the usual TCP options.
    else
      @host = @options?.host || localhost
      @port = @options?.port || 8007
      @path = @options?.path || ''
      @url = "#{@protocol}://#{@host}:#{@port}/#{@path}"

    # wss means secure websocket so we'll use https
    if @protocol == 'wss'
      @server = new https.Server(null, @options.credentials)

    # otherwise just use http
    else
      @server = new http.Server(null)

    # Create the WebSocket server providing the http(s) server
    # created just above.
    #
    @wss = new ws.Server(server: @server)
    @wss.on('connection', (ws) =>
      try
        @log("WS_RMI_Server: trying new connection: ", ws: ws)
        conn = new @Connection(this, ws, @options)
        @connections.push(conn)
        @log("connection added:", 'conn.id': conn.id)
      catch error
        msg = "\nWS_RMI_Server_Common: "
        msg += "\nError in connection event handler"
        new Error(msg))


  # Method start()
  # Start the server.
  #
  start: =>
    try

      # Unix domain socket so just use @path
      if @protocol == 'ws+unix'
        @server.listen(path: @path)
        stats = fs.statSync(@path)
        uid = @options.uid || stats.uid
        gid = @options.gid || stats.gid
        fs.chownSync(@path, uid, gid)

      # otherwise start with TCP options
      else
        @server.listen(host: @host, port: @port)

      @log("WS_RMI_Server started.", url: @url)

    catch error
      @log error

  cleanup: =>
    if fs.existsSync(@path)
      fs.unlinkSync(@path)
      process.exit()


  # Method stop()
  # Stop the server.
  #
  # TODO: stop() should be called before exiting. Isn't there a way to do
  # automatic cleanup?  Or am I thinking of Python or something else?
  #
  stop: =>
    @server.close()
    @log("server stopped.")


module.exports = WS_RMI_Server
