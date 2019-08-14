#!/bin/env/ coffee
#
# ws_rmi_client
#

# works both in browser and in node
WebSocket = window?.WebSocket || require('ws')

if not window?
  { WS_RMI_Connection } = require('./app')


class WS_RMI_Client

  # Connnection should be a sub-class of WS_RMI_Connection in order to
  # create and register desired WS_RMI_Objects at construction.
  #
  constructor: (options, @objects, Connection) ->
    @Connection = Connection || WS_RMI_Connection
    @id = "WS_RMI_Client-#{Math.random().toString()[2..]}"
    { @host, @port, @path, @protocol, @log_level } = options
    @url = "#{@protocol}://#{@host}:#{@port}/#{@path}"

  connect: (url) =>
    try
      @url = url if url
      ws = new WebSocket(@url)
      @connection = new @Connection(this, ws, @log_level)
      console.log("Connection added, id: #{@connection.id}")
      return

    catch error
      msg = "\nWS_RMI_Client: connect failed."
      msg += " url: #{@url}"
      new Error(msg)




if not window?
  exports.WS_RMI_Client = WS_RMI_Client

else
  window.WS_RMI_Client = WS_RMI_Client
