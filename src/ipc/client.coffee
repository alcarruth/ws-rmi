#!/bin/env/ coffee
#
# ipc/client.coffee
#

{ IPC } = require('node-ipc')
{ RMI_Connection } = require('../rmi')
{ Faux_WS } = require ('./faux-ws')


class IPC_RMI_Client

  # Connnection must be a sub-class of RMI_Connection in order to
  # create and register desired RMI_Objects at construction.
  #
  constructor: (Connection, @objects, @options, ipc_config) ->
    @log_level = @options.log_level || 2
    @log = @options.log || console.log

    @ipc = new IPC()
    @ipc.config[k] = v for k,v of ipc_config

    @Connection = Connection || RMI_Connection
    @id = "RMI_Client-#{Math.random().toString()[2..]}"


  #--------------------------------------------------------------------
  # connect() and disconnect() methods
  #

  connect: =>
    new Promise (resolve, reject) =>
      try
        @ipc.connectTo(@ipc.config.id, =>
          @socket = @ipc.of[@ipc.config.id]
          @faux_ws = new Faux_WS(@socket)
          @connection = new @Connection(this, @faux_ws, @options)
          resolve(@connection))

      catch error
        msg = "\nIPC_RMI_Client: connect failed."
        msg += error.toString() + '\n'
        msg += error.stack.split('\n').filter((x)-> /ipc-rmi/.test(x)).join('\n')
        @log(msg)
        @log(error)



  disconnect: =>
    if @log_level > 0
      @log("disconnecting: id: ", @id)
    @socket.close()


exports.IPC_RMI_Client = IPC_RMI_Client
