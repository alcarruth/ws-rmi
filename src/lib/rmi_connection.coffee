# -*- coffee -*-
#
#  file: /src/lib/rmi_connection_separate.coffee
#  package: ws-rmi
#

{ random_id, Logger } = require('armazilla-util')

{ RMI_Object_Registry, RMI_Stub_Registry } = require('./rmi_registry')

#----------------------------------------------------------------------

class RMI_Connection


  # RMI_Connection is basically just a wrapper around a socket and is
  # intendend to be applied on both ends of the websocket.  @owner is
  # the rmi_client or the rmi_server which established this end of the
  # websocket.
  #
  # The idea here is that the connection, once established, is
  # symmetrical with both ends having the ability to request a remote
  # method invocation and to respond to such requests.
  #
  # TODO: I have not settled the design as yet.  Previously the RMI's
  # were requested by a RMI_Client and responded to by a RMI_Server.
  # My current thinking is that that functionality might be better off
  # here.
  #
  constructor: (@owner, @ws, @options) ->
    @id = random_id('RMI_Connection')
    @logger = new Logger(this, { threshold: 2, options: @options })
    @log = @logger.log
    @waiter = null

    @registry = @owner.registry
    @stub_registry = new RMI_Stub_Registry(this, @options)

    # RMI's are given a unique number and the Promise's resolve() and
    # reject() functions are kept as callbacks to be executed when an
    # RMI response is received. Properties @rmi_cnt and @rmi_hash are
    # each written and read by methods send_request() and
    # recv_response().
    #
    @rmi_cnt = 0
    @rmi_hash = {}

    # Events are mapped to handler methods defined below.
    #
    @ws.onopen = @on_Open
    @ws.onmessage = @on_Message
    @ws.onclose = @on_Close
    @ws.onerror = @on_Error

    true

  #--------------------------------------------------------------------
  # Event handlers
  #

  # TODO: is this event handled here or in client and server?  Seems
  # like by the time the connection object is constructed it's already
  # open.  Could it be closed and opened again?  I wouldn't think so
  # unless I implement that in the server and client code.  It'd have
  # to keep stale connection objects around and re-activate them when
  # connected again.
  #
  on_Open: (evt) =>
    # @log("connection opened: ", id: @id)

  # This is the "main event".  It's what we've all been waiting for!
  on_Message: (evt) =>
    #@log(evt.data)
    @recv_message(evt.data)

  # TODO: perhaps somebody should be notified here ?-) Who wanted this
  # connection in the first place?  Do we have their contact info?
  #
  on_Close: (evt) =>
    @log("peer disconnected.", evt.data)
    @owner.remove_connection(@id)

  # TODO: think of something to do here.
  on_Error: (evt) =>
    @log(evt.data)
    if @waiter
      clearInterval(@waiter)


  #----------------------------------------------------------
  #
  disconnect: =>
    @ws.close()

  init: =>
    await @stub_registry.init()

  ready: =>
    new Promise (resolve, reject) =>
      delay = 100
      max_tries = 100
      tries = 1
      try
        @log("max_tries: #{max_tries}, delay: #{delay} ms...")
        waiter = setInterval(( =>
          if @ws.readyState == @ws.OPEN
            clearInterval(waiter)
            resolve(true)
          else if tries >= max_tries
            clearInterval(waiter)
            @log("tries >= max_tries")
            reject("tries >= max_tries")
          else
            tries += 1
          ), delay)
      catch error
        reject(error)


  #--------------------------------------------------------------------
  # Generic messaging methods
  #

  # JSON.stringify and send.  Returns a promise.
  send_message: ({ type, msg }) =>
    @log({ type, msg })
    data = JSON.stringify({ type, msg })
    try
      await @ready()
      @ws.send(data)
    catch error
      @log(error)


  # JSON.parse and handle as appropriate.
  recv_message: (data) =>
    { type, msg } = JSON.parse(data)
    @log(type: type, msg: msg)

    if type == 'request'
      return @recv_request(msg)

    if type == 'response'
      return @recv_response(msg)

    else
      throw new Error("recv_message(): invalid type #{type}")



  #--------------------------------------------------------------------
  # Methods to Send and Receive RMI Requests
  #

  # Method send_request()
  send_request: ({ obj_id, method_name, args }) =>

    rmi_id = @rmi_cnt++
    msg = { rmi_id, obj_id, method_name, args }

    new Promise (resolve, reject) =>
      try
        @rmi_hash[rmi_id] = { msg, resolve, reject }
        @log(msg)
        @send_message({ type: 'request', msg: msg })
      catch error
        delete @rmi_hash[rmi_id]
        reject("send_message():\n  #{error.msg}")


  # Method recv_request()
  recv_request: ({ rmi_id, obj_id, method_name, args }) =>
    msg = { rmi_id, obj_id, method_name, args }
    @log(msg)
    try
      result = await @registry.handle_request({ obj_id, method_name, args })
      error = null
      @send_response({ rmi_id, result, error })
    catch err
      result = null
      @send_response({ rmi_id, result, error })


  #--------------------------------------------------------------------
  #  Methods to Send and Receive RMI Responses
  #

  # Method send_response()
  send_response : ({ rmi_id, result, error }) =>
    response = { rmi_id, result, error }
    @log(response)

    new Promise (resolve, reject) =>
      try
        @send_message(type: 'response', msg: response)
      catch error
        @log("Error in send_response():", msg: resonse)
        reject( {rmi_id, result, error} )


  # Method recv_resonse()
  recv_response : ({ rmi_id, result, error }) =>
    response = { rmi_id, result, error }
    @log(response)

    request = @rmi_hash[rmi_id]
    delete @rmi_hash[rmi_id]

    try
      if result
        request.resolve(result)
      else
        request.reject({request, error})
    catch error
      request.reject({request, error})


#----------------------------------------------------------------------

exports.RMI_Connection = RMI_Connection
