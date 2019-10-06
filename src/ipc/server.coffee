#!/bin/env/ coffee
#
# ipc/server.coffee
#

{ IPC } = require('node-ipc')
{ RMI_Connection } = require('../rmi')
{ Faux_WS } = require ('./faux-ws')


class IPC_RMI_Server

  # Connection should extend RMI_Connection in
  # order to add desired RMI_Objects at construction.
  #
  constructor: (@objects, @options, ipc_config) ->
    @id = "IPC_RMI_Server-#{Math.random().toString()[2..]}"
    @log_level = @options.log_level || 2
    @log = @options.log || console.log
    @connections = []

    @ipc = new IPC()
    @ipc.config[k] = v for k,v of ipc_config
    @ipc.serve =>
      @ipc.server.on('connect', (socket) =>
        try
          faux_ws = new Faux_WS(socket, @options, @ipc.server)
          @log("trying new connection: #{faux_ws}")
          @conn = new RMI_Connection(this, faux_ws, @options)
          @connections.push(@conn)
          @log("connection added: #{@conn.id}")
        catch error
          msg = "\nIPC_RMI_Server_Common: "
          msg += "\nError in connection event handler"
          msg += error.toString() + '\n'
          msg += error.stack.split('\n').filter((x)-> /ipc-rmi/.test(x)).join('\n')
          @log(msg))


  # Start the server.
  start: =>
    try
      @ipc.server.start()
      @log("server listening at: #{@path}")

    catch error
     @log error

  # Stop the server.
  stop: =>
    @ipc.server.stop()
    @log("server stopped.")


exports.IPC_RMI_Server = IPC_RMI_Server
