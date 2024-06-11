# -*- coffee -*-
#
#  file: /src/client/rmi_client.coffee
#  package: ws-rmi
#

WebSocket = window? && window.WebSocket || require('ws')
{ random_id, Logger } = require('armazilla-util')

{ RMI_Connection } = require('./rmi_connection')
{ RMI_Object_Registry } = require('./rmi_registry')


class RMI_Client

  # Connnection should be a sub-class of RMI_Connection in order to
  # create and register desired RMI_Objects at construction.
  #
  constructor: ({ objects, options, Socket, Connection }) ->
    @id = random_id(this)
    @objects = objects || {}
    @options = options || {}
    @Socket = Socket || WebSocket
    @Connection = Connection || RMI_Connection
    @registry = new RMI_Object_Registry({
      owner: this
      options: @options
      })
    @logger = new Logger(this, { threshold: 2, options: options })
    @log = @logger.log

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

  remove_connection: =>
    @connection = null

  add_object: ({ obj, method_names }) =>
    @objects[obj.id] = { obj, method_names }

  update_registry: =>
    @registry.update()


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
        @ws = new @Socket(@url)

        # Note: @ws exists but is not necessarily ready yet.  This
        # issue is addressed in the RMI_Connection.send_message()
        # method (q.v.)
        #
        @connection = new @Connection(this, @ws, @options)
        await @connection.init()
        resolve(@connection)

      catch error
        msg = "\nRMI_Client: connect failed.\n"
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


module.exports = { RMI_Client }
