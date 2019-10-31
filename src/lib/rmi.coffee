#!/bin/env/ coffee
#
#  rmi.coffee
#

#----------------------------------------------------------------------

class WS_RMI_Connection

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
  constructor: (@owner, @ws, options) ->
    @id = random_id('WS_RMI_Connection')
    @log = options?.log || console.log
    @log_level = options?.log_level || 2
    @waiter = null

    # WS_RMI_Objects are registered here with their id as key.  The
    # registry is used by method recv_request() which receives just an
    # id in the message and must look up the object to invoke it's
    # method.
    #
    @registry = {}
    @exclude = []

    # Pseudo-object 'admin' with method 'init'
    #
    # TODO: Is it better to use this pseudo-object approach or just
    # instantiate WS_RMI_Object to the same effect?  The point is that
    # 'admin' is special in that it is present at Connection creation
    # time.  It should be excluded from init() responses since the
    # caller already has it.  Should it then be excluded from the
    # registry or just skipped over when responding to init?  The
    # benefit of including it in the registry is that it requires no
    # special treatment in method recv_request().  My current choice
    # is to include it in the registry here and skip over it in
    # init().
    #
    # In the future there may be other objects of this administrative
    # sort.  Maybe a more structured general solution should be
    # considered.
    #
    @admin =
      id: 'admin'
      name: 'admin'
      get_stub_specs: @get_stub_specs
      method_names: ['get_stub_specs']

    @registry['admin'] = @admin
    @exclude.push('admin')

    @stubs = {}

    # RMI's are given a unique number and the Promise's resolve() and
    # reject() functions are kept as callbacks to be executed when an
    # RMI response is received. Properties @rmi_cnt and @rmi_hash are
    # each written and read by methods send_request() and
    # recv_response().
    #
    @rmi_cnt = 0
    @rmi_hash = {}

    # add remote objects
    @log("@owner.objects: #{@owner.objects}")
    for obj in @owner.objects
      @add_object(obj)

    # Events are mapped to handler methods defined below.
    #
    # TODO: the chrome WebSocket class has no 'on' method, but the
    # 'ws' library does.  Need to simplify.
    #
    if @ws.on
      @ws.on('open', @on_Open)
      @ws.on('message', @on_Message)
      @ws.on('close', @on_Close)
      @ws.on('error', @on_Error)
    else
      # TODO: these might work for the 'ws' websocket library also.
      # If so, we can lose the above case and just use the following
      # else part.  Try it in ipc mode.
      #
      @ws.onopen = (e) => @on_Open(e.data)
      @ws.onmessage = (e) => @on_Message(e.data)
      @ws.onclose = (e) => @on_Close(e.data)
      @ws.onerror = (e) => @on_Error(e.data)

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
    @log("connection opened: id:", @id)
    @init_stubs()

  # This is the "main event".  It's what we've all been waiting for!
  on_Message: (data) =>
    if @log_level > 1
      @log("WS_RMI_Connection.on_Message(): ", data)
    @recv_message(data)

  # TODO: perhaps somebody should be notified here ?-) Who wanted this
  # connection in the first place?  Do we have their contact info?
  #
  on_Close: (evt) =>
    if @log_level > 1
      @log("peer disconnected: id:", @id)

  # TODO: think of something to do here.
  on_Error: (evt) =>
    @log(evt.data)
    if @waiter
      clearInterval(@waiter)


  #----------------------------------------------------------
  #
  disconnect: =>
    @ws.close()


  #----------------------------------------------------------
  # Object registry methods

  # Register a WS_RMI_Object for RMI
  add_object: (obj) =>
    @registry[obj.id] = obj
    obj.register(this)

  register: (obj) =>
    @registry[obj.id] = obj

  # I refuse to comment on what this one does.
  del_object: (id) =>
    delete @registry[id]

  # Method get_stub_specs() is a server side built-in remote method.
  # It is invoked by method invoke_stubs() on the client side. (see
  # below)
  #
  get_stub_specs: =>

    new Promise((resolve, reject) =>
      try
        specs = {}
        for id, obj of @registry
          if id not in @exclude
            specs[id] =
              name: obj.name
              method_names: obj.method_names
        if @log_level > 1
          @log("get_stub_specs():", specs)
        resolve(specs)

      catch error
        @log("Error: init():", specs, error)
        reject("Error: init():", specs))

  # Call get_stub_specs() on the server side, then build the local
  # stubs for the remote objects' methods.
  #
  init_stubs: =>

    # callback
    cb = (result) =>
      if @log_level > 1
        @log("init_stubs(): cb(): result:", result)
      for id, spec of result
        { name, method_names } = spec
        stub = new WS_RMI_Stub(id, name, method_names, this)
        @stubs[stub.name] = stub

    # error handler
    eh = (error) =>
      if @log_level > 1
        @log("init_stubs(): eh(): received error:", error)
      @log("init_stubs(): eh(): received error:", error)

    if @log_level > 1
      @log("init_stubs(): begin")

    # @send_request() returns a promise
    @send_request('admin', 'get_stub_specs', []).then(cb).catch(eh)


  #--------------------------------------------------------------------
  # Generic messaging methods
  #

  # JSON.stringify and send.  Returns a promise.
  send_message: (data_obj) =>

    if @log_level > 1
      @log("send_message(): data_obj:", data_obj)
      @log("@ws.readyState = #{@ws.readyState}")

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
      @log("Error: send_message(): data_obj:", data_obj)
      @log error


  # JSON.parse and handle as appropriate.
  recv_message: (data) =>

    if @log_level > 1
      @log("WS_RMI_Connection.recv_message() ")
      @log("data: #{data}")

    { type, msg } = JSON.parse(data)

    if @log_level > 1
      @log("type: #{type}")
      @log("msg: #{msg}")

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
  send_request: (obj_id, method, args) =>

    msg = { obj_id: obj_id, method: method, args: args }
    if @log_level > 1
      @log("send_request(): msg:", msg)

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
  recv_request: (msg) =>

    if @log_level > 1
      @log("recv_request(): msg:", msg)

    { obj_id, method, args, rmi_id } = msg

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
  send_response : (rmi_id, result, error) =>
    msg = { rmi_id: rmi_id, result: result, error: error }

    if @log_level > 1
      @log("send_response(): msg:", msg)

    new Promise (resolve, reject) =>
      try
        @send_message(type: 'response', msg: msg)
      catch error
        @log("Error in send_response():", msg)
        reject({rmi_id, result, error})


  # Method recv_resonse()
  recv_response : (response) =>
    if @log_level > 1
      @log("recv_response(): response:", response)
    try
      { rmi_id, result, error } = response
      { request, resolve, reject } = @rmi_hash[rmi_id]
      if error
        reject({request, error})
      else
        resolve(result)
    catch error
      reject({request, error})


#----------------------------------------------------------------------
# WS_RMI_Object

# used in WS_RMI_Object constructor
random_id = (name) ->
  "#{name}_#{Math.random().toString()[2..]}"

# RMI_Object wraps a regular coffeescript class instance object,
# exposing only those methods explicitly intended for RMI.
#
class WS_RMI_Object

  constructor: (@name, @obj, @method_names, options) ->
    @options = options
    @log_level = options?.log_level || 0
    @log = options?.log || console.log
    @id = random_id(@name)

    for name in @method_names
      this[name] = ((name) =>
        (args...) ->
          @invoke(name, args))(name)

  register: (connection) =>
    @connection = connection

  # Method invoke() is called by connection.recv_request() it executes
  # the appropriate method and returns a promise.
  #
  invoke: (method_name, args) ->

    # error handler used in .catch() just below.
    eh = (err) =>
      msg = "\nWS_RMI_Object:"
      msg += (id: @id, method: name, args: args).toString()
      return new Error(msg)

    if @log_level > 1
      @log("invoke(): ", {method_name, args})

    # call the method of the underlying object
    @obj[method_name].apply(@obj, args) # .catch(eh)


#-----------------------------------------------------------------------
# WS_RMI_Stub

class WS_RMI_Stub

  constructor: (@id, @name, @method_names, @connection, options) ->
    @log_level = options?.log_level || 0
    @log = options?.log || console.log

    for name in @method_names
      this[name] = ((name) =>
        (args...) ->
          @invoke(name, args))(name)

  # Method invoke() implements local stub methods by calling
  # WS_RMI_Connection.send_request() which returns a Promise.
  #
  invoke: (name, args) ->
    if @log_level > 1
      @log("invoke(): ", {name, args})

    eh = (err) =>
      msg = "\nWS_RMI_Stub:"
      msg += (id: @id, method: name, args: args).toString()
      return new Error(msg)

    @connection.send_request(@id, name, args).catch(eh)


#----------------------------------------------------------------------

exports.Connection = WS_RMI_Connection
exports.Object = WS_RMI_Object
exports.Stub = WS_RMI_Stub
