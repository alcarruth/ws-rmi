#!/usr/bin/env coffee
#
#  faux-ws.coffee
#

{ IPC } = require('node-ipc')
{ EventEmitter } = require('events')


random_id = (name) ->
  "#{name}_#{Math.random().toString()[2..]}"


class Faux_WS extends EventEmitter

  constructor: (@socket, options={}, @server=null) ->
    super()
    @log = options?.log || console.log
    @log_level = options?.log_level || 0
    @id = random_id('faux-ws')

    if @server
      @server.on('connect', @on_Connect)
      @server.on('disconnect', @on_Disconnect)
      @server.on('rmi-message', @on_Message)
      @server.on('error', @on_Error)

    else
      @socket.on('connect', @on_Connect)
      @socket.on('disconnect', @on_Disconnect)
      @socket.on('rmi-message', @on_Message)
      @socket.on('error', @on_Error)

  on_Connect: (args...) =>
    @emit('open', args)

  on_Disconnect: (args...) =>
    @emit('close', args)

  on_Message: (data, socket) =>
    @log("Faux_WS.on_Message(): ")
    { id, message } = data
    @emit('message', message)

  on_Error: (args...) =>
    @emit('error', args)

  send: (msg) =>

    # If the connection object was created by a server then @server is
    # defined and we invoke it like this:
    #
    if @server
      @server.emit(@socket, 'rmi-message',
        id: @id
        message: msg)

    # And if the connection object was created by a client then we just
    # invoke it like this:
    #
    else
      @socket.emit('rmi-message',
        id: @id
        message: msg)


exports.Faux_WS = Faux_WS
