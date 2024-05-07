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
    @stubs = new RMI_Stub_Registry(this, @options)

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
    @log("RMI_Connection.on_Message(): ", evt.data)
    @recv_message(evt.data)

  # TODO: perhaps somebody should be notified here ?-) Who wanted this
  # connection in the first place?  Do we have their contact info?
  #
  on_Close: (evt) =>
    @log("peer disconnected: ", id: @id)

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
    await @stubs.init()

  #--------------------------------------------------------------------
  # Generic messaging methods
  #

  # JSON.stringify and send.  Returns a promise.
  send_message: (data_obj) =>

    @log("send_message(): ",
      data_obj: data_obj,
      '@ws.readyState': @ws.readyState)

    try
      # The WebSocket API seems flawed.  When a new ws is created as
      # in 'new WebSocket(url)' it attempts to connect to the server
      # at url.  Until then ws.readyState == ws.CONNECTING and any
      # attempt to send a message will throw an error.  An 'open'
      # event is emmitted when ws.readyState == ws.OPEN and you can
      # set ws.onOpen to handle this event, but only AFTER the attempt
      # to connect has already begun.  So there is a race condition
      # between setting the handler and completing the connect
      # protocol.
      #
      # The code below is intended to handle this.  It runs every time
      # send_message() is called but is really only necessary in the
      # beginning when the ws has just been created.
      #

      # If the ws is connected then proceed as normal.
      #
      if @ws.readyState == @ws.OPEN
        @ws.send(JSON.stringify(data_obj))


      # If not ready but we're still connecting, then check again
      # every ${delay} ms.
      #
      else if @ws.readyState == @ws.CONNECTING
        delay = 100
        max_tries = 30
        tries = 0
        @waiter = setInterval(( =>
          @log("waiting #{delay} ms...")
          tries += 1
          if @ws.readyState == @ws.OPEN || tries >= max_tries
            clearInterval(@waiter)
            @ws.send(JSON.stringify(data_obj))), delay)


      # The other possible states are CLOSED and CLOSING.  Either
      # of these is an error.
      #
      else
        throw new Error('ws.readyState not OPEN or CONNECTING')

    catch error
      @log("Error: send_message(): ",
        data_obj: data_obj,
        error: error)


  # JSON.parse and handle as appropriate.
  recv_message: (data) =>

    @log("RMI_Connection.recv_message() ", data: data)

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
  send_request: ({ obj_id, method, args }) =>

    msg = { obj_id, method, args }
    @log("send_request(): ", msg: msg )

    new Promise (resolve, reject) =>
      try
        msg.rmi_id = @rmi_cnt++
        @rmi_hash[msg.rmi_id] =
          msg: msg
          resolve: resolve
          reject: reject
        @send_message(type: 'request', msg: msg)
      catch error
        reject("send_message(): Error: data_obj:", data_obj)


  # Method recv_request()
  recv_request: ({ obj_id, method_name, args }) =>
    @registry.handle_request({ obj_id, method_name, args })

    @log("recv_request(): ", msg: { obj_id, method_name, args })

    # callback used below
    cb = (res) => @send_response(rmi_id, res, null)

    # error handler used below
    eh = (err) => @send_response(rmi_id, null, err)

    # Look up the object and apply the method to the args.  Method is
    # assumed to return a promise.
    #
    obj = @registry[obj_id]
    obj[method].apply(obj, args).then(cb).catch(eh)


  #--------------------------------------------------------------------
  #  Methods to Send and Receive RMI Responses
  #

  # Method send_response()
  send_response : ({ rmi_id, result, error }) =>
    msg = { rmi_id, result, error }

    @log("send_response(): ", msg: msg)

    new Promise (resolve, reject) =>
      try
        @send_message(type: 'response', msg: msg)
      catch error
        @log("Error in send_response():", msg: msg)
        reject( {rmi_id, result, error} )


  # Method recv_resonse()
  recv_response : ({ rmi_id, result, error }) =>
    response = { rmi_id, result, error }
    @log("recv_response(): ", response: response)
    try
      { request, resolve, reject } = @rmi_hash[rmi_id]
      if error
        reject({request, error})
      else
        resolve(result)
    catch error
      reject({request, error})


#----------------------------------------------------------------------

exports.RMI_Connection = RMI_Connection
