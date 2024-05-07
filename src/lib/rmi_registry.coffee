#!/usr/bin/env coffee
#
#  file: /src/lib/rmi_registry.coffee
#

{ random_id, Logger } = require('armazilla-util')
{ RMI_Object, RMI_Stub } = require('./rmi_object')

#-----------------------------------------------------------------------
# RMI_Object_Registry
#
class RMI_Registry_Admin # extends RMI_Object

  constructor: (@registry) ->
    @id = random_id(this)
    @name = 'admin'
    @method_names = ['get_stub_specs']
    @logger = new Logger( obj: this, threshold: 0, options: @options )
    @log = @logger.log

  # Method get_stub_specs() is a server side built-in remote method.
  # It is invoked by method invoke_stubs() on the client side. (see
  # below)
  #
  get_stub_specs: =>
    try
      specs = []
      for obj_id, obj of @registry.objects
        if not @registry.exclude_ids[obj_id]?
          { name, method_names } = obj
          specs.push({ obj_id, name, method_names })
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
    @add_admin()
    @options = options || {}
    @logger = new Logger( obj: this, threshold: 0, options: @options )
    @log = @logger.log

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
    @objects[@admin.id] = @admin
    @exclude_ids[@admin.id] = true

  # Method add_object(obj, method_names)
  # obj: a coffeescript object
  # method_names: a list of methods to expose
  #
  add_object: ({ obj, method_names }) =>
    options = @options
    console.log "adding: #{obj}, method_names" #{method_names}"
    rmi_obj = new RMI_Object({ obj, method_names, options })
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
  handle_request: (request) =>
    @log(request)
    return new Promise (resolve, reject) =>
      try
        { obj_id, method_name, args } = request
        obj = @objects[obj_id]
        res = await obj[method_name](args...)
        resolve(res)
      catch err
        @log(request)


#-----------------------------------------------------------------------
# RMI_Stub_Registry
#
class RMI_Stub_Registry

  constructor: (@connection, @options = {}) ->
    @id = random_id(this)
    @stubs = {}
    @logger = new Logger( obj: this, threshold: 0, options: @options )

  # Method init_stubs(conn)
  # conn: an instance of RMI_Connection
  # Call get_stub_specs() on the server side of this connection,
  # then build the local stubs for the remote objects' methods.
  #
  init: =>
    try
      specs = await @connection.send_request(
        obj_id: 'admin'
        method_name: 'get_stub_specs'
        args: []
      )
      for { obj_id, name, method_names } in specs
        @add_stub({ obj_id, name, method_names })
    catch err
      @log("failed.", err)


  add_stub: ({ obj_id, name, method_names }) =>
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

module.exports = {
  RMI_Object_Registry
  RMI_Stub_Registry
}
