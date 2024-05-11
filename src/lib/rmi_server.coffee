# -*- coffee -*-
#
#  file: /src/server/rmi_server.coffee
#  package: ws-rmi
#

process = require('process')
userid = require('userid')
fs = require('fs')
ws = require('ws')
http = require('http')
https = require('https')

{ random_id, Logger } = require('armazilla-util')
{ RMI_Connection } = require('./rmi_connection')
{ RMI_Object_Registry } = require('./rmi_registry')

# An instance of RMI_Server provides remote method invocation (RMI)
# services for its @objects to clients connected by a websocket.
#
class RMI_Server

  # @objects: an array of remotable objects
  #
  # @options: options for the http(s) server and for logging etc.
  #
  # Connection: a connection class extending RMI_Connection.
  # It defaults to RMI_Connection.  A subclass can be used to provide
  # extra functionality particular to the type of rmi objects being served.
  # At this point the only known reason for providing this option is for
  # the db_rmi stuff which required additional setup after @init_stubs().
  # It seems like this might frequently be the case though...
  #
  constructor: ({ objects, options, Socket, Connection }) ->
    @id = random_id(this)
    @objects = objects || {}
    @options = options || {}
    @Socket = Socket || null
    @Connection = Connection || RMI_Connection
    @registry = new RMI_Object_Registry({
      owner: this
      options: @options
      })
    @logger = new Logger(this, { threshold: 2, options: options })
    @log = @logger.log

    # connections added here as they are created
    @connections = {}

    # default to 'ws+unix'
    @protocol = @options?.protocol || 'ws+unix'


    #-----------------------------------------------------------------------
    # system event handlers


    # Catch 'exit' (Ctrl-D)
    process.on('exit', =>
      @log("RMI_Server: received 'exit' (Ctrl-D)")
      #@stop()
      )

    # Catch 'SIGQUIT'
    process.on('SIGQUIT', =>
      @log("RMI_Server: received 'SIGQUIT'"))

    # Catch 'SIGINT' (Ctrl-C)
    process.on('SIGINT', =>
      @log("RMI_Server: received 'SIGINT' (Ctrl-C)")
      @stop()
      process.exit()
      )


    #-----------------------------------------------------------------------
    # set url according to protocol

    # Protocol 'ws+unix' means IPC (inter process communication),
    # basically unix domain sockets (or something similar in
    # Windows). See docs for npm package ws.
    #
    if @protocol == 'ws+unix'
      @path = @options?.path || '/tmp/ipc_rmi'
      @url = "ws+unix://#{@path}"

      # if fs.existsSync(@path)
      #   fs.unlinkSync(@path)
      #   process.exit())

    # Otherwise we need the usual TCP options.
    else
      @host = @options?.host || localhost
      @port = @options?.port || 8007
      @path = @options?.path || ''
      @url = "#{@protocol}://#{@host}:#{@port}/#{@path}"


    #-----------------------------------------------------------------------
    # set @server according to protocol

    # wss means secure websocket so we'll use https
    if @protocol == 'wss'
      @server = new https.Server(null, @options.credentials)

    # otherwise just use http
    else
      @server = new http.Server(null)


    #-----------------------------------------------------------------------
    # Create the WebSocket server providing the http(s) server
    # created just above.

    @wss = new ws.Server(server: @server)
    @wss.on('connection', (ws) =>
      try
        @log("RMI_Server: trying new connection: ", ws: ws)
        conn = new @Connection(this, ws, @options)
        @add_connection(conn)
        await conn.init()
      catch error
        msg = "\nRMI_Server_Common: "
        msg += "\nError in connection event handler"
        new Error(msg))


  #-----------------------------------------------------------------------
  # Methods

  add_connection: (conn) =>
    @connections[conn.id] = conn
    @log("connection added:", 'conn.id': conn.id)

  remove_connection: (id) =>
    delete @connections[id]
    @log("connection removed:", 'conn.id': id)

  add_object: ({ obj, method_names }) =>
    @objects[obj.id] = { obj, method_names }
    @registry.update()

  update_registry: =>
    @registry.update()

  # Method start()
  # Start the server.
  #
  start: =>
    try
      # Unix domain socket so just use @path
      if @protocol == 'ws+unix'
        @server.listen(path: @path)
        stats = fs.statSync(@path)
        uid = userid.uid(@options.user)
        gid = userid.gid(@options.group)
        mode = @options.mode || 0o664
        fs.chmodSync(@path, mode)
        fs.chownSync(@path, uid, gid)
        # @log("fs.chownSync(#{@path}, #{uid}, #{gid})")


      # otherwise start with TCP options
      else
        @server.listen(host: @host, port: @port)

      @log("RMI_Server started.", url: @url)

    catch error
      @log error


  cleanup: =>
    if fs.existsSync(@path)
      fs.unlinkSync(@path)
      process.exit()


  # Method stop()
  # Stop the server.
  #
  # TODO: stop() should be called before exiting. Isn't there a way to do
  # automatic cleanup?  Or am I thinking of Python or something else?
  #
  stop: =>
    @server.close()
    @log("server stopped.")


exports.RMI_Server = RMI_Server
