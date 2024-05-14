

#!/usr/bin/env coffee
#
#  file: /src/lib/rmi_object.coffee
#

WebSocket = window? && window.WebSocket || require('ws')

if window?
  inspect = (x, options) -> return x
else
  { inspect } = require('util')

#----------------------------------------------------------------------
#  armazilla-util
#

# returns a randomized id string
random_id = (obj, name) ->
  name = name || obj.constructor.name
  "#{name}_#{Math.random().toString()[2..]}"

class Logger

  constructor: ({ @obj, options, threshold }) ->
    @owner_id = @obj?.id || null
    @options =
      colors: options?.colors || true
      depth: options?.depth || null
    @threshold = if threshold? then threshold else 2

  _log: (xs, type='') =>
    #function_name = (await stacktrace.get())[2].functionName
    #console.log("\n#{type}#{function_name}():")
    console.log(@obj)
    for x in xs
      console.log(inspect(x, @options))
    return undefined

  log_level: (level, xs...) =>
    if level >= @threshold
      @log(xs...)

  log: (xs...) =>
    @_log(xs)
    console.trace()

  info: (xs...) =>
    @_log(xs, 'INFO: ')

  warn: (xs...) =>
    @_log(xs, 'WARNING: ')

  error: (xs...) =>
    @log(xs, 'ERROR: ')


#----------------------------------------------------------------------
# RMI_Object
#
# RMI_Object wraps a regular coffeescript class instance object,
# exposing only those methods explicitly intended for RMI.
#
class RMI_Object

  constructor: ({ obj, name, method_names, options }) ->
    @id = random_id(this)
    @obj = obj
    @name = name || @id
    @method_names = method_names || []
    @options = options || {}
    @logger = new Logger( obj: this, threshold: 0, options: options )
    @log = @logger.log

    for name in @method_names
      this[name] = ((method_name) =>
        (args...) =>
          @invoke({ method_name, args }))(name)

  get_stub_spec: => return {
    obj_id: @id
    name: @name
    method_names: @method_names
    }

  # Method invoke() is called by connection.recv_request() it executes
  # the appropriate method and returns a promise.
  #
  invoke: ({ method_name, args }) =>
    obj_id = @id
    @log({ obj_id, method_name, args })
    return new Promise (resolve, reject) =>
      try
        # call the method of the underlying object
        #res = @obj[method_name].apply(@obj, args)
        res = @obj[method_name](args...)
        resolve(res)
      catch err
        @logger.log("rmi failed", {method_name, args})
        reject(err.msg)


#-----------------------------------------------------------------------
# RMI_Stub

class RMI_Stub

  constructor: ({ obj_id, name, method_names, send_request, options }) ->
    @id = random_id(this)
    @obj_id = obj_id
    @name = name || @obj_id
    @method_names = method_names || []
    @send_request = send_request || null
    @options = options || {}
    @logger = new Logger( obj: this, threshold: 0, options: @options )
    @log = @logger.log

    for name in @method_names
      this[name] = ((method_name) =>
        (args...) ->
          @invoke({ method_name, args }))(name)

  # Method invoke() implements local stub methods by calling
  # RMI_Connection.send_request() which returns a Promise.
  #
  invoke: ({ method_name, args }) =>
    obj_id = @obj_id
    request = { obj_id, method_name, args }
    @log(request)
    return new Promise (resolve, reject) =>
      try
        res = @send_request(request)
        resolve(res)
      catch err
        @log("rmi failed", request)
        reject(err.msg)

#----------------------------------------------------------------------

#!/usr/bin/env coffee
#
#  file: /src/lib/rmi_registry.coffee
#

#-----------------------------------------------------------------------
# RMI_Object_Registry
#
class RMI_Registry_Admin # extends RMI_Object

  constructor: (@registry) ->
    @id = 'admin'
    @name = 'admin'
    @method_names = ['get_stub_specs']
    @logger = new Logger( obj: this, threshold: 0, options: @options )
    @log = @logger.log

  get_stub_spec: => return {
    obj_id: @id
    name: @name
    method_names: @method_names
    }

  # Method get_stub_specs() is a server side built-in remote method.
  # It is invoked by method invoke_stubs() on the client side. (see
  # below)
  #
  get_stub_specs: =>
    try
      specs = (obj.get_stub_spec() for id, obj of @registry.objects)
      excluded = (k for k,v of @registry.exclude_ids)
      specs = specs.filter((obj) -> obj.id not in excluded)
      return specs

    catch error
      @log(specs, error.msg)


#-----------------------------------------------------------------------
# RMI_Object_Registry
#
class RMI_Object_Registry

  constructor: ({ owner, connection, options }) ->
    @id = random_id(this)
    @objects = {}
    @exclude_ids = {}
    @set_owner(owner)
    @set_connection(connection) || null
    @options = options || {}
    @logger = new Logger( obj: this, threshold: 0, options: @options )
    @log = @logger.log
    @add_admin()

  set_owner: (owner) =>
    @owner = owner

  update: =>
    @objects = {}
    @add_admin()
    for id, spec of @owner.objects
      { obj, method_names } = spec
      @add_object({ obj, method_names })

  set_connection: (connection) =>
    @connection = connection || null

  exclude: (obj) =>
    @exclude_ids[obj.id]

  include: (obj) =>
    delete @exclude_ids[obj.id]

  add_admin: =>
    @admin = new RMI_Registry_Admin(this)
    @log(@admin.get_stub_spec())
    @objects[@admin.id] = @admin
    @exclude_ids[@admin.id] = true

  # Method add_object(obj, method_names)
  # obj: a coffeescript object
  # method_names: a list of methods to expose
  #
  add_object: ({ obj, name, method_names }) =>
    name = name || obj.name
    options = @options
    rmi_obj = new RMI_Object({ obj, name, method_names, options })
    id = rmi_obj.id
    @log({ id, name, method_names })
    @objects[rmi_obj.id] = rmi_obj
    # why?
    # rmi_obj.connection = @connection

  # Method get_object(id)
  # id: the id of the object to get
  #
  get_object: (obj_id) =>
    return @objects[obj_id]

  # Method del_object(id)
  # id: the id of the object to delete
  #
  del_object: (obj_id) =>
    if obj_id not in @exclude
      delete @objects[obj_id]

  # Method handle_request(request)
  # request: a request JSON string
  #
  handle_request: ({ obj_id, method_name, args }) =>
    request = { obj_id, method_name, args }
    @log(request)
    return new Promise (resolve, reject) =>
      try
        obj = @objects[obj_id]
        result = await obj[method_name](args...)
        @log({ request, result })
        resolve(result)
      catch err
        reject(err)


#-----------------------------------------------------------------------
# RMI_Stub_Registry
#
class RMI_Stub_Registry

  constructor: (@connection, @options = {}) ->
    @id = random_id(this)
    @stubs = {}
    @logger = new Logger( obj: this, threshold: 0, options: @options )
    @log = @logger.log

  # Method init_stubs(conn)
  # conn: an instance of RMI_Connection
  # Call get_stub_specs() on the server side of this connection,
  # then build the local stubs for the remote objects' methods.
  #
  init: =>
    request = {
      obj_id: 'admin'
      method_name: 'get_stub_specs'
      args: []
      }
    try
      specs = await @connection.send_request(request)
      @log(specs)
      for { obj_id, name, method_names } in specs
        @add_stub({ obj_id, name, method_names })
    catch err
      @log("failed.", err)


  add_stub: ({ obj_id, name, method_names }) =>
    @log({ obj_id, name, method_names })
    send_request = @connection.send_request
    @stubs[obj_id] = new RMI_Stub({ obj_id, name, method_names, send_request })

  del_stub: (obj_id) =>
    delete @stubs[obj_id]

  get_stub: (obj_id) =>
    return @stubs[obj_id]

  get_stubs_by_name: (name) =>
    stubs = (stub for _, stub of @stubs)
    return stubs.filter((x) -> x.name == name)


#-----------------------------------------------------------------------
#
#

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

  #--------------------------------------------------------------------
  # Generic messaging methods
  #

  # JSON.stringify and send.  Returns a promise.
  send_message: ({ type, msg }) =>
    @log({ type, msg })
    data = JSON.stringify({ type, msg })

    try

      # If the ws is connected then proceed as normal.
      #
      if @ws.readyState == @ws.OPEN
        @ws.send(data)

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
            @ws.send(data, delay)))

      # The other possible states are CLOSED and CLOSING.  Either
      # of these is an error.
      #
      else
        throw new Error('ws.readyState not OPEN or CONNECTING')

    catch error
      @log({ data, error })



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
#

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


#----------------------------------------------------------------------
#

class Stack

  constructor: ->
    @id = random_id(this)
    @name = 'stack'
    @stack = []

  push: (x) =>
    new Promise (resolve, reject) =>
      try
        resolve(@stack.push(x))
        console.log @stack
      catch error
        reject(error)

  pop: =>
    new Promise (resolve, reject) =>
      try
        resolve(@stack.pop())
        console.log @stack
      catch error
        reject(error)


#----------------------------------------------------------------------
#

class Test_Client extends RMI_Client
  constructor: (@examples = []) ->
    options = {
      protocol: 'wss'
      port: 443
      host: 'alcarruth.net'
      path: '/wss/ws-rmi-example'
    }
    super({ options })
    @logger = new Logger( obj: this, threshold: 0, options: options )
    @log = @logger.log
    @add_examples()

  add_examples: (examples = @examples) =>
    for example in examples
      @add_object({
        obj: new example.Class()
        method_names: example.method_names
        })

  fun_one: =>
    @fun_two()

  fun_two: =>
    @fun_three()

  fun_three: =>
    @log("Hi Al!")

#----------------------------------------------------------------------

remote_client = new Test_Client([
#  { Class: Stack, method_names: [ 'push', 'pop' ] }
])


if window?
  window.client = remote_client
else
  module.exports = remote_client
