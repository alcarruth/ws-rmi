# -*- coffee -*-
#
# src/client/ws_rmi_client.coffee
#

# This should work both in browser and in node
WebSocket = window?.WebSocket || require('ws')


# TODO:  What about WS_RMI_Stub?  Is it not used?
# Answer: it is used in WS_RMI_Connection.  All the stubs
# are associated with the connection.  Is this good?  Should
# they maybe all be hanging off the client?
#
{
  WS_RMI_Connection
  WS_RMI_Object
  WS_RMI_Stub
  random_id
  #
} = require('../common')


class WS_RMI_Client

  # Connnection should be a sub-class of WS_RMI_Connection in order to
  # create and register desired WS_RMI_Objects at construction.
  #
  constructor: (@objects, @options = {}, Connection) ->
    @id = random_id("WS_RMI_Client")
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

    @connection = null
    @Connection = Connection || RMI_Connection


  #--------------------------------------------------------------------
  # connect() method
  #

  connect: (url) =>
    @log("RMI_Client.connect():", id: @id)

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
        resolve(@connection)

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
      @log("disconnecting:", id: @id)
    @ws.close()


exports.WS_RMI_Client = WS_RMI_Client
