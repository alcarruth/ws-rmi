#!/bin/env/ coffee
#
# ws_rmi_client
#

# works both in browser and in node
WebSocket = window?.WebSocket || require('ws')
{ RMI_Connection } = require('./rmi')


class WS_RMI_Client

  # Connnection should be a sub-class of WS_RMI_Connection in order to
  # create and register desired WS_RMI_Objects at construction.
  #
  constructor: (Connection, @objects, @options = {}) ->
    @log_level = @options.log_level || 2
    @log = @options.log || console.log

    { host, port, path, protocol } = @options
    @url = "#{protocol}://#{host}:#{port}/#{path}"

    @Connection = Connection || RMI_Connection
    @id = "WS_RMI_Client-#{Math.random().toString()[2..]}"


  #--------------------------------------------------------------------
  # connect() method
  #

  connect: (url) =>
    @log("ws_rmi_client: id:", @id)
    @log("ws connectiing ...")

    new Promise (resolve, reject) =>

      try
        @url = url if url

        # Note: This is screwed up !!!
        # new WebSocket(@url) connects automatically but ws.onOpen
        # cannot be set until AFTER the ws object is constructed!
        # So the 'open' event can be emitted BEFORE the handler is set!
        # See note below ...
        #
        @ws = new WebSocket(@url)

        # Note: @ws exists but is not necessarily ready yet.  This
        # issue is addressed in the WS_RMI_Connection.send_message()
        # method (q.v.)
        #
        @connection = new @Connection(this, @ws, @options)
        resolve(connection)

      catch error
        msg = "\nWS_RMI_Client: connect failed.\n"
        msg += error.toString() + '\n'
        msg += error.stack.split('\n').filter((x)-> /ws-rmi/.test(x)).join('\n')
        @log(msg)



  #--------------------------------------------------------------------
  # disconnect() method
  #

  disconnect: =>
    if @log_level > 0
      @log("disconnecting: id: ", @id)
    @ws.close()


exports.WS_RMI_Client = WS_RMI_Client
